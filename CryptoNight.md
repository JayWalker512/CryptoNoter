The following text is from the [Cryptonight spec](https://cryptonote.org/cns/cns008.txt), with comments to try and explain my understanding.


1. Introduction

   CryptoNight is a memory-hard hash function.  It is designed to be
   inefficiently computable on GPU, FPGA and ASIC architectures.
   
    
    > By memory-hard, they mean that calculating the hash requires more storage than a typical GPU or ASIC provides, which provide fast computation but have limited memory.  This is why it does not perform well on those devices.
   
     The
   CryptoNight algorithm's first step is initializing large scratchpad
   with pseudo-random data.    
   
    > The scratchpad is the memory requirement referred to above.  'Pseudo-random' means that the data appears to be random but is always the same given the same inputs.
   
   The next step is numerous read/write
   operations at pseudo-random addresses contained in the scratchpad.

    > Reading/writing to the scratchpad like this creates a pseudo-random scratchpad, just like what we had before this step... but this makes the process take longer, and is what makes the process inefficient on GPUs and ASICs.
 
   The final step is hashing the entire scratchpad to produce the
   resulting value.
 
    > Hashing is the process of converting data of any size into a fixed sized pseudo-random number. 

2. Definitions

   hash function: an efficiently computable function which maps data of
   arbitrary size to data of fixed size and behaves similarly to a
   random function

   > The Hash Function is the method used for hashing.  If you know the hash function, and are given the same input, the result will always be the same.

   scratchpad: a large area of memory used to store intermediate values
   during the evaluation of a memory-hard function

    > The scratchpad is a large amount of data, we'll be reading and writing to specific parts of this throughout.

3. Scratchpad Initialization

   First, the input is hashed using Keccak [KECCAK] with parameters b =
   1600 and c = 512.
   
   > Keccak is better known as SHA-3 (using a 256 bit key).  The input, when using NiceHash, is the blob converted from hex to a byte[76].  The bytes 39-42 are interpreted as the nOnce (a long) and incremented before the Hash is taken.  

   > This produces a byte[200], filled with pseudo-random data.

    The bytes 0..31 of the Keccak final state are
   interpreted as an AES-256 key [AES] 
   
   > The hash calculated by Keccak is 200 bytes, which is then logically split into 4 separate segments. The first segment of the hash (bytes 0 to 31 inclusive) is the key used for [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard).  
   
    and expanded to 10 round keys.

      > The 32 byte AES key uses the [Rijndael key schedule](https://en.wikipedia.org/wiki/Rijndael_key_schedule) to create 10 separate keys, known as 'round keys'.  Standard AES encryption also creates round keys, we simply modified how many round keys were generated.  'Round' here is referring to iterations, so 10 round keys is 1 unique key for each of the 10 iterations we will perform.

   A
   scratchpad of   bytes (2 MiB) is allocated.
   
   > This is the memory we will be reading and writing to in the steps below.
   
    The bytes 64..191
   are extracted from the Keccak final state and split into 8 blocks of
   16 bytes each.

   > The third segment of the hash (bytes 64 to 191) is the data we will encrypt using AES.  We interpret this segment of data as a byte[8][16] (8 blocks with 16 bytes each). 
   
    Each block is encrypted using the following procedure:

```
      for i = 0..9 do:
          block = aes_round(block, round_keys[i])
```

   Where aes_round function performs a round of AES encryption, which
   means that SubBytes, ShiftRows and MixColumns steps are performed on
   the block, and the result is XORed with the round key. Note that
   unlike in the AES encryption algorithm, the first and the last rounds
   are not special. 

   > This process is near standard AES encryption.  Each block is encrypted using each round key, sequentially (so 8 blocks * 10 rounds per block means 80 AES rounds so far).  The only difference from AES encryption is the 'initial round' and 'final round' as [described here](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard#High-level_description_of_the_algorithm) are excluded.
   
   The resulting blocks are written into the first 128
   bytes of the scratchpad. 

   > Copy the data from the blocks into the scratchpad. 
   
   Then, these blocks are encrypted again in
   the same way, and the result is written into the second 128 bytes of
   the scratchpad. Each time 128 bytes are written, they represent the
   result of the encryption of the previously written 128 bytes. The
   process is repeated until the scratchpad is fully initialized.

   > Loop 16,384 times, reusing the blocks each time it loops (so 8 blocks * 10 rounds * 16,384 scratchpad regions = a total of 1,310,720 AES rounds).

   This diagram illustrates scratchpad initialization:

```
                               +-----+
                               |Input|
                               +-----+
                                  |
                                  V
                             +--------+
                             | Keccak |
                             +--------+
                                  |
                                  V
   +-------------------------------------------------------------+
   |                         Final state                         |
   +-------------+--------------+---------------+----------------+
   | Bytes 0..31 | Bytes 32..63 | Bytes 64..191 | Bytes 192..199 |
   +-------------+--------------+---------------+----------------+
          |                             |
          V                             |
   +-------------+                      V
   | Round key 0 |------------+---+->+-----+
   +-------------+            |   |  |     |
   |      .      |            |   |  |     |
   |      .      |            |   |  | AES |
   |      .      |            |   |  |     |
   +-------------+            |   |  |     |
   | Round key 9 |----------+-|-+-|->+-----+                 +---+
   +-------------+          | | | |     |                    |   |
                            | | | |     +------------------->|   |
                            | | | |     |                    |   |
                            | | | |     V                    |   |
                            | | | +->+-----+                 |   |
                            | | |    |     |                 | S |
                            | | |    |     |                 |   |
                            | | |    | AES |                 | c |
                            | | |    |     |                 |   |
                            | | |    |     |                 | r |
                            | | +--->+-----+                 |   |
                            | |         |                    | a |
                            | |         +------------------->|   |
                            | |         .                    | t |
                            | |         .                    |   |
                            | |         .                    | c |
                            | |         +------------------->|   |
                            | |         |                    | h |
                            | |         V                    |   |
                            | +----->+-----+                 | p |
                            |        |     |                 |   |
                            |        |     |                 | a |
                            |        | AES |                 |   |
                            |        |     |                 | d |
                            |        |     |                 |   |
                            +------->+-----+                 |   |
                                        |                    |   |
                                        +------------------->|   |
                                                             |   |
                                                             +---+

```
              Figure 3: Scratchpad initialization diagram


4. Memory-Hard Loop

   Prior to the main loop, bytes 0..31 and 32..63 of the Keccak state
   are XORed, and the resulting 32 bytes are used to initialize
   variables a and b, 16 bytes each. These variables are used in the
   main loop.
   
   > The first and second segment of the Keccak hash are XORed together to create byte[16] a and byte[16] b.
   
     The main loop is iterated 524,288 times.
     
     > This loop should be where most of the time is spent (pending confirmation).
     
      When a 16-byte
   value needs to be converted into an address in the scratchpad, it is
   interpreted as a little-endian integer, and the 21 low-order bits are
   used as a byte index. However, the 4 low-order bits of the index are
   cleared to ensure the 16-byte alignment.
   
   > We use bitwise AND in order to drop the bits referenced above.e
   > to_scratchpad_address(ulong a) => (int)(a & 0x1FFFF0)
   
    The data is read from and
   written to the scratchpad in 16-byte blocks.
   
   > The variables a and b created above are 16-bytes each.  This code will modify these values and use them as both addresses and values in order to change the scratchpad.

    Each iteration can be
   expressed with the following pseudo-code:

```
      scratchpad_address = to_scratchpad_address(a)
      scratchpad[scratchpad_address] = aes_round(scratchpad 
        [scratchpad_address], a)
      b, scratchpad[scratchpad_address] = scratchpad[scratchpad_address],
        b xor scratchpad[scratchpad_address]
      scratchpad_address = to_scratchpad_address(b)
      a = 8byte_add(a, 8byte_mul(b, scratchpad[scratchpad_address]))
      a, scratchpad[scratchpad_address] = a xor 
        scratchpad[scratchpad_address], a
```

   Where, the 8byte_add function represents each of the arguments as a
   pair of 64-bit little-endian values and adds them together,
   component-wise, modulo 2^64. The result is converted back into 16
   bytes.

   > 8byte_add(Int128 a, Int128 b) => return new Int128(a.High + b.High, a.Low + b.Low);
   > Note that each term (e.g. a.High + b.Low) may overflow, this is expected.

   The 8byte_mul function, however, uses only the first 8 bytes of each
   argument, which are interpreted as unsigned 64-bit little-endian
   integers and multiplied together. The result is converted into 16
   bytes, and finally the two 8-byte halves of the result are swapped.

```csharp
       Int128 8byte_mul(Int128 a, Int128 b) {
            Int128 mul = new Int128(0, idx0) * new Int128(0, cl);
            return new Int128(mul.Low, mul.High);
       }
```
   This diagram illustrates the memory-hard loop:


```
   +-------------------------------------------------------------+
   |                         Final state                         |
   +-------------+--------------+---------------+----------------+
   | Bytes 0..31 | Bytes 32..63 | Bytes 64..191 | Bytes 192..199 |
   +-------------+--------------+---------------+----------------+
          |             |
          |   +-----+   |
          +-->| XOR |<--+
              +-----+
               |   |
          +----+   +----+
          |             |
          V             V
        +---+         +---+
        | a |         | b |
        +---+         +---+
          |             |
   --------------------- REPEAT 524288 TIMES ---------------------
          |             |                            address +---+
          +-------------|----------------------------------->|   |
          |   +-----+   |                               read |   |
          +-->| AES |<--|------------------------------------|   |
          |   +-----+   V                                    |   |
          |      |   +-----+                                 | S |
          |      +-->| XOR |                                 |   |
          |      |   +-----+                           write | c |
          |      |      |    +------------------------------>|   |
          |      |      +----+                       address | r |
          |      +------------------------------------------>|   |
          |      |  +-----------+                       read | a |
          |      +->| 8byte_mul |<--+------------------------|   |
          |      |  +-----------+   |                        | t |
          |      |        |         |                        |   |
          |      |        V         |                        | c |
          |      |  +-----------+   |                        |   |
          +------|->| 8byte_add |   |                        | h |
                 |  +-----------+   |                        |   |
                 |        |         |                  write | p |
                 |        +---------|----------------------->|   |
                 |        |         |                        | a |
                 |        V         |                        |   |
                 |     +-----+      |                        | d |
                 |     | XOR |<-----+                        |   |
                 |     +-----+                               |   |
                 +------+ |                                  |   |
          +-------------|-+                                  |   |
          |             |                                    +---+
   -------------------------- END REPEAT -------------------------
          |             |
```

5. Result Calculation

   After the memory-hard part, bytes 32..63 from the Keccak state are
   expanded into 10 AES round keys in the same manner as in the first
   part.

   > The second segment from the original Keccak Hash is now used as the AES key to create 10 new round keys, like we had above for the first segment.

   Bytes 64..191 are extracted from the Keccak state and XORed with the
   first 128 bytes of the scratchpad.
   
   > This is the third segment from the Hash, the same data we encrypted to create the scratchpad above.
   snth
   
    Then the result is encrypted in
   the same manner as in the first part, but using the new keys.
   
   > Another 80 AES rounds per scratchpad segment.
   
    The
   result is XORed with the second 128 bytes from the scratchpad,
   encrypted again, and so on. 

   After XORing with the last 128 bytes of the scratchpad, the result is
   encrypted the last time,
   
   > For a total of another 1,310,720 aes rounds
   
    and then the bytes 64..191 in the Keccak
   state are replaced with the result.
   
   > Update the hash code.

    Then, the Keccak state is passed
   through Keccak-f (the Keccak permutation) with b = 1600. 

   > aoeu

   Then, the 2 low-order bits of the first byte of the state are used to
   select a hash function: 0=BLAKE-256 [BLAKE], 1=Groestl-256 [GROESTL],
   2=JH-256 [JH], and 3=Skein-256 [SKEIN]. The chosen hash function is
   then applied to the Keccak state, and the resulting hash is the
   output of CryptoNight.

   The diagram below illustrates the result calculation:

```
   +-------------------------------------------------------------+
   |                         Final state                         |
   +-------------+--------------+---------------+----------------+
   | Bytes 0..31 | Bytes 32..63 | Bytes 64..191 | Bytes 192..199 |
   +-------------+--------------+---------------+----------------+
         |                |             |                |
         |       +--------+             |                |
         |       V        |             |                |
         |+-------------+ |             |                |
         || Round key 0 |-|---+---+     |                |
         |+-------------+ |   |   |     |                |
         ||      .      | |   |   |     |                |
         ||      .      | |   |   |     |                |
         ||      .      | |   |   |     |                |
         |+-------------+ |   |   |     |                |
   +---+ || Round key 9 |-|-+-|-+ |     V                |
   |   | |+-------------+ | | | | |  +-----+             |
   |   |-|----------------|-|-|-|-|->| XOR |             |
   |   | |                | | | | |  +-----+             |
   | S | |                | | | | |     |                |
   |   | |                | | | | |     V                |
   | c | |                | | | | +->+-----+             |
   |   | |                | | | |    |     |             |
   | r | |                | | | |    |     |             |
   |   | |                | | | |    | AES |             |
   | a | |                | | | |    |     |             |
   |   | |                | | | |    |     |             |
   | t | |                | | | +--->+-----+             |
   |   | |                | | |         |                |
   | c | |                | | |         V                |
   |   | |                | | |      +-----+             |
   | h |-|----------------|-|-|----->| XOR |             |
   |   | |                | | |      +-----+             |
   | p | |                | | |         |                |
   |   | |                | | |         .                |
   | a | |                | | |         .                |
   |   | |                | | |         .                |
   | d | |                | | |         |                |
   |   | |                | | |         V                |
   |   | |                | | |      +-----+             |
   |   |-|----------------|-|-|----->| XOR |             |
   |   | |                | | |      +-----+             |
   +---+ |                | | |         |                |
         |                | | |         V                |
         |                | | +----->+-----+             |
         |                | |        |     |             |
         |                | |        |     |             |
         |                | |        | AES |             |
         |                | |        |     |             |
         |                | |        |     |             |
         |                | +------->+-----+             |
         |                |             |                |
         V                V             V                V
   +-------------+--------------+---------------+----------------+
   | Bytes 0..31 | Bytes 32..63 | Bytes 64..191 | Bytes 192..199 |
   +-------------+--------------+---------------+----------------+
   |                       Modified state                        |
   +-------------------------------------------------------------+
                                  |
                                  V
                            +----------+
                            | Keccak-f |
                            +----------+
                             |    |
                 +-----------+    |
                 |                |
                 V                V
          +-------------+  +-------------+
          | Select hash |->| Chosen hash |
          +-------------+  +-------------+
                                  |
                                  V
                          +--------------+
                          | Final result |
                          +--------------+               
```
                  Figure 5: Result calculation diagram


   Hash examples:
```
      Empty string:
      eb14e8a833fac6fe9a43b57b336789c46ffe93f2868452240720607b14387e11.

      "This is a test":
      a084f01d1437a09c6985401b60d43554ae105802c5f5d8a9b3253649c0be6605.
```

































Seigen et al.          CryptoNight Hash Function                [Page 9]
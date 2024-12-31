import java.io.*;
import java.util.*;

public class cachesim {

    static Scanner traceFileScanner;

    // Struct describing an access from the trace file. Returned by `traceNextAccess`.
    private static class CacheAccess {

        boolean isStore;
        int address;
        int accessSize;
        byte data[];
    }

    /**
     * Opens a trace file, given its name. Must be called before `traceNextAccess`,
     * which will begin reading from this file.
     * @param filename: the name of the trace file to open
     */
    public static void traceInit(String filename) {
        try {
            traceFileScanner = new Scanner(new File(filename));
        } catch (FileNotFoundException e) {
            System.err.println("Failed to open trace file: " + e.getMessage());
            System.exit(1);
        }
    }

    /**
     * Checks if we've already read all accesses from the trace file.
     * @return true if the trace file is complete, false if there's more to read.
     */
    public static boolean traceFinished() {
        return !traceFileScanner.hasNextLine();
    }

    /**
     * Read the next access in the trace. Errors if `traceFinished() == true`.
     * @return The access as a `cacheAccess` struct.
     */
    public static CacheAccess traceNextAccess() {
        String[] parts = traceFileScanner.nextLine().trim().split("\\s+");
        CacheAccess result = new CacheAccess(); // to hold parsed information

        // Parse address and access size
        result.address = Integer.parseInt(parts[1].substring(2), 16); // skips prefix, converts hex string into decimal int
        result.accessSize = Integer.parseInt(parts[2]); // size of access in decimal
        // System.out.printf("%d", result.accessSize);

        // Check access type
        if (parts[0].equals("store")) { // value to be written if it's a store
            result.isStore = true;

            // Read data
            result.data = new byte[result.accessSize];
            for (int i = 0; i < result.accessSize; i++) {
                result.data[i] = (byte) Integer.parseInt(
                    parts[3].substring(i * 2, 2 + i * 2),
                    16
                );
            }
        } else if (parts[0].equals("load")) {
            result.isStore = false;
        } else {
            System.err.println("Invalid trace file access type" + parts[0]);
            System.exit(1);
        }
        return result;
    }
    // Your code can go here (or anywhere in this class), including a `public static void main` method.

    // cache math helper function from hw doc
    public static int log2(int n) {
        int r = 0;
        while ((n >>= 1) != 0) {
            r++;
        }
        return r;
    }

    // frame class
    public static class Frame {
        boolean valid;
        boolean dirty;
        int tag;
        byte[] data;

        // constructor for initialization
        public Frame(boolean valid, boolean dirty, int tag, byte[] data) {
            this.valid = valid;
            this.dirty = dirty;
            this.tag = tag;
            this.data = data;
        }
    }

    public static int bitMask(int offsetSize) {
        int shift = (1 << offsetSize);
        return shift - 1;
    }

    public static void updateArray(byte[] source, int source_idx, byte[] dest, int dest_idx, int size) {
        for (int i = 0; i < size; i++) {
            dest[dest_idx + i] = source[source_idx + i];
        }
    }

    public static void main(String[] args) {

        // for correct exit code
        if (args.length != 4) {
            System.err.println("Please follow this format: java cachesim <trace-file> <cache-size-kB> <associativity> <block-size>");
            System.exit(0);
        }

        // parse args
        String traceFile = args[0];
        int cacheSizeKB = Integer.parseInt(args[1]);
        int associativity = Integer.parseInt(args[2]);
        int blockSize = Integer.parseInt(args[3]);

        // cache math
        int cacheSize = cacheSizeKB * 1024;  // Convert KB to bytes
        int totalBlocks = cacheSize / blockSize;
        int numSets = totalBlocks / associativity;

        int offsetBitsSize = log2(blockSize); // block offset size
        int indexBitsSize = log2(numSets); // 

        // initialize cache
        // basically, the cache is a list of sets, with each set being a Queue<Frame> (FIFO)
        ArrayList <Queue<Frame>> cache = new ArrayList<>(numSets);
        
        // populate cache
        for (int i = 0; i < numSets; i++){
            cache.add(new LinkedList<Frame>());
        }

        byte[] memory = new byte[1<<24];
        // populate memory
        for (int i = 0; i < memory.length; i++) {
            memory[i] = 0;
        }
        // read file
        traceInit(traceFile);

        while (!traceFinished()){
            CacheAccess access = traceNextAccess();

            // process the access
            int offset = access.address & bitMask(offsetBitsSize); // bit masking stuff to get offsetBitsSize least significant bits
            int index = (access.address >> offsetBitsSize) & bitMask(indexBitsSize); // move address bits to get rid of offset bits, 
                                                                                        // then do bit masking stuff to get indexBitsSize least significant bits
            int tag = access.address >> (offsetBitsSize + indexBitsSize); // move address bits to get rid of offset bits and index bits -> isolate tag bits

            // get set from cache, bc each set is a Queue<Frame> 
            Queue<Frame> set = cache.get(index);

            // check cache for desired block -> search our set for the frame
            Frame frameHit = null;
            for (Frame frame: set){
                // we have a hit!
                if (frame.valid && frame.tag == tag) {
                    frameHit = frame;
                    break;
                }
            }

            // printing address- needs to be in base 16, but remember that access.address is in base 10
            String base16_address = Integer.toHexString(access.address);
            //System.out.printf("0x%s ", base16_address);

            // handling hit
            if (frameHit != null) {
                // if it's a store, we need to mark the bit as dirty and update our hit frame with the new data
                if (access.isStore) {
                    System.out.printf("store ");
                    System.out.printf("0x%s ", base16_address);
                    System.out.printf("hit \n");
                    updateArray(access.data, 0, frameHit.data, offset, access.accessSize);
                    frameHit.dirty = true; 
                }
                // otherwise it's a load, so we print the loaded value
                // need to make sure we're printing all of the bytes from frameHit.data ranging from offset to offset + accessSize
                else {
                    System.out.printf("load ");
                    System.out.printf("0x%s ", base16_address);
                    System.out.printf("hit ");
                    for (int i = 0; i < access.accessSize; i++) {
                        System.out.printf("%02x", frameHit.data[offset + i]);
                    }
                    System.out.printf("\n");
                }
                // newline for formatting
                //System.out.printf("\n");
            }
            
            // handling miss
            else {
                //System.out.printf("miss "); // this needs to be moved

                // eviction for full set
                if (set.size() >= associativity) {
                    Frame victim = set.remove(); // get head of the queue
                    if (victim.valid) {
                        // dirty or clean for frame
                        String frame_state = "clean ";
                        if (victim.dirty) {
                            frame_state = "dirty ";
                        }

                        // address for eviction - basically just getting our stuff back into the correct place
                        // except offset bits are not here b/c those are all 0's

                        int evict_shift = victim.tag << (indexBitsSize + offsetBitsSize);
                        int index_shift = index << offsetBitsSize;
                        int evict_addy = evict_shift | index_shift;

                        // print these out
                        //System.out.printf("\n");
                        System.out.printf("replacement 0x%x ", evict_addy);
                        System.out.printf("%s \n", frame_state);

                        // write back if dirty
                        if (victim.dirty) {
                            // write to memory, memory[evict_addy] to memory[evict_addy + blockSize]
                            // writing victim.data[0] to victim.data[blockSize]
                            updateArray(victim.data, 0, memory, evict_addy, blockSize); 
                        }
                    }
                }
                
                int blockAddress = access.address & (-blockSize);

                byte[] new_data = new byte[blockSize];

                //System.out.println(memory + " " + blockAddress + " "+ new_data + " " + offset + " " + blockSize);

                // write to new_data, new_data[0] to new_data[0 + blockSize]
                // writing memory[blockAddress], memory[blockAddress + blockSize]
                updateArray(memory, blockAddress, new_data, 0, blockSize);

                Frame nextFrame = new Frame(true, false, tag, new_data);

                // more store/load handling
                if (access.isStore) {
                    System.out.printf("store ");
                    System.out.printf("0x%s ", base16_address); // idk if this address is right
                    System.out.printf("miss");
                    // writing to nextFrame.data, nextFrame.data[offset] to nextFrame.data[offset + accessSize]
                    // writing access.data; access.data[0], access.data[accessSize]
                    updateArray(access.data, 0, nextFrame.data, offset, access.accessSize);
                    nextFrame.dirty = true;
                    System.out.printf("\n");
                } else {
                    System.out.printf("load ");
                    System.out.printf("0x%s ", base16_address); // idk if this address is right
                    System.out.printf("miss ");
                    for (int i = 0; i < access.accessSize; i++) {
                        System.out.printf("%02x", nextFrame.data[offset + i]);
                    }
                    System.out.printf("\n");
                }

                set.add(nextFrame);

                cache.set(index, set);

                // newline for formatting
                //System.out.printf("\n");
            }
        }

        // close trace file scanner
        traceFileScanner.close();
        System.exit(0);
    }
}

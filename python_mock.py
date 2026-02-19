from pynq import Overlay, MMIO
import numpy as np
import time

# 1. Load the Bitstream (Your teammate's current build or a simple BRAM test build)
ol = Overlay("design.bit") 

# Map the two BRAMs (Option a: Two individual BRAMs) [cite: 14, 71]
# Note: Match these strings to your teammate's actual IP names in Vivado
instr_key = next(k for k in ol.mem_dict if "instr" in k.lower())
data_key  = next(k for k in ol.mem_dict if "data" in k.lower() or "ctrl_1" in k.lower())

instr_bram = MMIO(ol.mem_dict[instr_key]["phys_addr"], ol.mem_dict[instr_key]["addr_range"])
data_bram  = MMIO(ol.mem_dict[data_key]["phys_addr"], ol.mem_dict[data_key]["addr_range"])

# --- TEST PART 1: INJECTION ---
print("Testing Injection...")
test_val = 0x12345678
data_bram.write(0x40, test_val)
read_back = data_bram.read(0x40)

if read_back == test_val:
    print("Injection Test: PASSED")
else:
    print(f"Injection Test: FAILED (Sent {hex(test_val)}, Got {hex(read_back)})")

# --- TEST PART 2: THE FULL MOCK PROCEDURE ---

# A. Prepare Data [cite: 106]
input_array = np.random.randint(-100, 100, size=32, dtype=np.int32)
golden_result = sorted(input_array.tolist()) # Python's reference 

# B. Inject [cite: 107]
for i, val in enumerate(input_array):
    data_bram.write(0x40 + (i * 4), int(val))
data_bram.write(0x2000, 0x0) # Clear Status Flag [cite: 108]

print("Script is now polling. MANUALLY run the next cell to simulate Hardware Finishing.")

# C. Polling Loop 
# This loop will hang here until the next cell (or the Core) writes the flag
while True:
    status = data_bram.read(0x2000)
    if status == 0xCAFEBABE:
        print("Mock Hardware: DONE signal received!") [cite: 125]
        break
    time.sleep(0.5)

# D. Verification [cite: 127, 129]
results = []
for i in range(32):
    val = data_bram.read(0x40 + (i * 4))
    if val & 0x80000000: val -= 1 << 32 # Signed conversion
    results.append(val)

if results == golden_result:
    print("SUCCESS: Result matches Golden Result!") [cite: 130]
else:
    print("FAILURE: Results do not match.")
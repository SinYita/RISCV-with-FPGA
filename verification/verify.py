from pynq import Overlay, MMIO
import time

# -----------------------------
# Address map
# -----------------------------
INST_BASE = 0x4000_0000
DATA_BASE = 0x4200_0000
GPIO_BASE = 0x4120_0000

IMEM_SIZE = 0x2000
DMEM_SIZE = 0x2000

DONE_OFF = 0x1FFC
DONE_ADDR = DATA_BASE + DONE_OFF

# AXI GPIO regs (Xilinx AXI GPIO)
GPIO_DATA = 0x0
GPIO_TRI = 0x4
GPIO_DATA2 = 0x8
GPIO_TRI2 = 0xC

# -----------------------------
# Load overlay
# -----------------------------
ol = Overlay("soc_design.bit")

inst_mmio = MMIO(INST_BASE, IMEM_SIZE)
data_mmio = MMIO(DATA_BASE, DMEM_SIZE)
gpio_mmio = MMIO(GPIO_BASE, 0x10)

# -----------------------------
# GPIO setup: ch1 input(done), ch2 output(rst_n)
# -----------------------------
gpio_mmio.write(GPIO_TRI,  0xFFFF_FFFF)  # ch1 input
gpio_mmio.write(GPIO_TRI2, 0x0000_0000)  # ch2 output


def set_reset_n(val: int):
    gpio_mmio.write(GPIO_DATA2, val & 0x1)


def read_hw_done():
    return gpio_mmio.read(GPIO_DATA) & 0x1


def hold_reset(t=0.01):
    set_reset_n(0)
    time.sleep(t)


def release_reset(t=0.005):
    set_reset_n(1)
    time.sleep(t)


def load_imem(words):
    # Load program into IMEM while core is in reset
    for i, w in enumerate(words):
        inst_mmio.write(i * 4, w)


def imem_readback(n_words=4):
    out = []
    for i in range(n_words):
        out.append(inst_mmio.read(i * 4))
    return out


def dmem_read32(off):
    return data_mmio.read(off)


def dmem_write32(off, val):
    data_mmio.write(off, val)


def scan_dmem_for(value, max_hits=10):
    hits = []
    for i in range(DMEM_SIZE // 4):
        if data_mmio.read(i * 4) == value:
            hits.append(i * 4)
            if len(hits) >= max_hits:
                break
    return hits


# -----------------------------
# Mini programs (RV32I, little-endian word list)
# -----------------------------
# CPU writes 0x11111111 to DATA_BASE + 0x0, then loops
mini_data0_code = [
    0x42000437,  # lui  s0,0x42000       s0=0x42000000
    0x111112B7,  # lui  t0,0x11111       t0=0x11111000
    0x11128293,  # addi t0,t0,0x111      t0=0x11111111
    0x00542023,  # sw   t0,0(s0)
    0x0000006F,  # jal  x0,0
]

# CPU writes 0xDEADBEEF to DATA_BASE + 0x1FFC, then loops
mini_done_code = [
    0x42002E37,  # lui  t3,0x42002       t3=0x42002000
    0xFFCE0E13,  # addi t3,t3,-4         t3=0x42001FFC
    0xDEADCEB7,  # lui  t4,0xDEADC       t4=0xDEADC000
    0xEEFE8E93,  # addi t4,t4,-0x111     t4=0xDEADBEEF
    0x01DE2023,  # sw   t4,0(t3)
    0x0000006F,  # jal  x0,0
]

# -----------------------------
# Step 0: PS path sanity
# -----------------------------
print("=== PS->DMEM sanity ===")
dmem_write32(0x100, 0x12345678)
print("DMEM[0x100] readback =", hex(dmem_read32(0x100)))

print("\n=== GPIO sanity ===")
hold_reset(0.01)
print("GPIO2 rst_n drive (should be 0):", gpio_mmio.read(GPIO_DATA2) & 1)
release_reset(0.01)
print("GPIO2 rst_n drive (should be 1):", gpio_mmio.read(GPIO_DATA2) & 1)
print("GPIO1 done input =", read_hw_done())

# -----------------------------
# Helper to run a mini program and check effects
# -----------------------------


def run_mini(name, program_words, wait_s=0.05):
    print(f"\n=== RUN: {name} ===")

    # 1) Hold reset so CPU doesn't execute while we load IMEM
    hold_reset(0.02)

    # 2) Load program
    load_imem(program_words)

    # 3) IMEM readback check
    rb = imem_readback(min(4, len(program_words)))
    print("IMEM readback:", [hex(x) for x in rb])

    # 4) Release reset to run
    release_reset(0.005)

    # 5) Wait a bit
    time.sleep(wait_s)


# -----------------------------
# Test 1: CPU writes DMEM[0]
# -----------------------------
# Clear DMEM[0] first so we see change
hold_reset(0.01)
dmem_write32(0x0, 0x0)
release_reset(0.001)

run_mini("mini_data0_code (CPU store to DATA_BASE+0)",
         mini_data0_code, wait_s=0.05)

val0 = dmem_read32(0x0)
print("DMEM[0] after CPU run =", hex(val0))
print("EXPECT 0x11111111 ->", "PASS" if val0 == 0x11111111 else "FAIL")

# -----------------------------
# Test 2: CPU writes DONE_ADDR
# -----------------------------
hold_reset(0.01)
dmem_write32(DONE_OFF, 0x0)
release_reset(0.001)

run_mini("mini_done_code (CPU store to DONE_ADDR)",
         mini_done_code, wait_s=0.05)

flag = dmem_read32(DONE_OFF)
print("DONE flag after CPU run =", hex(flag))
print("EXPECT 0xDEADBEEF ->", "PASS" if flag == 0xDEADBEEF else "FAIL")

# If FAIL, scan DMEM to see if it wrote elsewhere
if flag != 0xDEADBEEF:
    hits = scan_dmem_for(0xDEADBEEF, max_hits=10)
    print("Scan DMEM for 0xDEADBEEF hits at offsets:", [hex(x) for x in hits])

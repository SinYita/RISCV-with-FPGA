from pynq import Overlay, MMIO
import time
import random

# -----------------------------
# Address map (请确保与 Vivado Address Editor 完全一致)
# -----------------------------
INST_BASE = 0x4000_0000
DATA_BASE = 0x4200_0000
GPIO_BASE = 0x4120_0000

IMEM_SIZE = 0x2000
DMEM_SIZE = 0x2000

DONE_OFF  = 0x1FFC
DONE_ADDR = DATA_BASE + DONE_OFF

# AXI GPIO regs
GPIO_DATA  = 0x0
GPIO_TRI   = 0x4
GPIO_DATA2 = 0x8
GPIO_TRI2  = 0xC

# -----------------------------
# Load overlay
# -----------------------------
print("Loading Overlay...")
ol = Overlay("soc_design.bit")

inst_mmio = MMIO(INST_BASE, IMEM_SIZE)
data_mmio = MMIO(DATA_BASE, DMEM_SIZE)
gpio_mmio = MMIO(GPIO_BASE, 0x10)

# -----------------------------
# GPIO setup:
# ch1 input (done), ch2 output (rst_n control)
# -----------------------------
gpio_mmio.write(GPIO_TRI,  0xFFFF_FFFF)  # ch1 input
gpio_mmio.write(GPIO_TRI2, 0x0000_0000)  # ch2 output

def read_hw_done():
    return gpio_mmio.read(GPIO_DATA) & 0x1

def set_reset_n(val: int):
    # val=0 => reset asserted (CPU 冻结)
    # val=1 => release reset  (CPU 运行)
    gpio_mmio.write(GPIO_DATA2, val & 0x1)

# -----------------------------
# 汇编机器码
# -----------------------------
bubble_sort_code = [
    0x42000437, 0x00700293, 0x00542023, 0x00300293,
    0x00542223, 0x00500293, 0x00542423, 0x00200293,
    0x00542623, 0x00900293, 0x00542823, 0x00100293,
    0x00542A23, 0x00800293, 0x00542C23, 0x00400293,
    0x00542E23, 0x00700493, 0x02048E63, 0x00900933,
    0x008009B3, 0x02090463, 0x0009A283, 0x0049A303,
    0x005323B3, 0x00038663, 0x0069A023, 0x0059A223,
    0x00498993, 0xFFF90913, 0xFDDFF06F, 0xFFF48493,
    0xFC9FF06F, 0x42002E37, 0xFFCE0E13, 0xDEADCEB7,
    0xEEFE8E93, 0x01DE2023, 0x0000006F
]

EXPECTED_A = [1, 2, 3, 4, 5, 7, 8, 9]

def run_mode_A(timeout=2.0):
    print("--- Starting CPU ---")
    
    # 1) 按住复位！将 CPU 冻结
    set_reset_n(0)
    time.sleep(0.01)

    # 2) 清理标志位，防止上次运行的残留导致误判
    data_mmio.write(DONE_OFF, 0x0)

    # 3) 安全加载指令到 IMEM
    for i, w in enumerate(bubble_sort_code):
        inst_mmio.write(i*4, w)

    # 4) 释放复位！CPU 正式从第一条指令起跑
    set_reset_n(1)
    
    # 5) 轮询等待结束
    start = time.time()
    while (time.time() - start) < timeout:
        flag = data_mmio.read(DONE_OFF)
        hw = read_hw_done()
        if flag == 0xDEADBEEF or hw == 1:
            print(f"[DONE] Mem={hex(flag)} HW={hw} t={time.time()-start:.4f}s")
            break
        time.sleep(0.005)
    else:
        print(f"[TIMEOUT] Mem={hex(data_mmio.read(DONE_OFF))} HW={read_hw_done()}")

    # 6) 读取结果
    result = [data_mmio.read(i*4) for i in range(8)]
    print("Result[0..7] =", result)
    print("Expect       =", EXPECTED_A)
    print("PASS" if result == EXPECTED_A else "FAIL")

# 运行测试
print(f"DONE_ADDR = {hex(DONE_ADDR)}")
run_mode_A()

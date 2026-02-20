from pynq import Overlay, MMIO
import time
import random

ol = Overlay("soc_design.bit")

INST_BASE = 0x40000000
DATA_BASE = 0x42000000
GPIO_BASE = 0x41200000  # used for reset

inst_mmio = MMIO(INST_BASE, 0x2000)   # 8KB
data_mmio = MMIO(DATA_BASE, 0x2000)   # 8KB
gpio_mmio = MMIO(GPIO_BASE, 0x10)     # GPIO 

bubble_sort_code = [
    0x42000437, 0x02000493, 0x00000293, 0x04928263, 
    0x00000313, 0x40548933, 0xfff90913, 0x02c30a63, 
    0x00231393, 0x008383b3, 0x0003a203, 0x0043a283, 
    0x01d2a333, 0x00030463, 0x01d3a023, 0x0143a223, 
    0x00130313, 0xfd9ff06f, 0x00128293, 0xfc1ff06f, 
    0x42002fb7, 0xffcf8f93, 0xdeadcf37, 0xeeff0f13, 
    0x01efa023, 0x0000006f
]
gpio_mmio.write(0x8,0x0)
random_data = [random.randint(0, 255) for _ in range(32)]
print(f"array: {random_data}")

for i, val in enumerate(random_data):
    data_mmio.write(i * 4, val)

for i, code in enumerate(bubble_sort_code):
    inst_mmio.write(i * 4, code)

#clean the done signal 
data_mmio.write(0x1FFC, 0x0)

print("All set !")

#release the reset signal
print("Starting the Riscv core...")
print("Releasing Reset signal via GPIO2...")
gpio_mmio.write(0x8, 0x1)
start_time = time.time()
timeout = 5 

while (time.time() - start_time) < timeout:
    flag = data_mmio.read(0x1FFC)       # 软件标志位 (Magic Number)
    hw_flag = gpio_mmio.read(0x0) & 0x1 # 硬件引脚信号 (GPIO Channel 1)

    if flag == 0xDEADBEEF or hw_flag == 1:
        print(f"Done signal detected! (Mem: {hex(flag)}, HW: {hw_flag})")
        print(f"Time used: {time.time()-start_time:.4f}s")
        found_done = True
        break
    time.sleep(0.01)

sorted_result = []
for i in range(32):
    sorted_result.append(data_mmio.read(i * 4))

print(f"Sorted Array: {sorted_result}")

if sorted_result == sorted(random_data):
    print("Pass!")
else:
    print("Fail")

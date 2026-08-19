<div align="center">
  <h1>🚀 RISC-V Mutex Core</h1>
  <p><b>Custom Hardware Lock Mechanism on RISC-V Architecture</b></p>

  ![Verilog](https://img.shields.io/badge/Verilog-101E3E?style=for-the-badge&logo=verilog&logoColor=white)
  ![RISC-V](https://img.shields.io/badge/RISC--V-000000?style=for-the-badge&logo=riscv&logoColor=white)
  ![OpenLane](https://img.shields.io/badge/OpenLane-00599C?style=for-the-badge)
  ![SKY130](https://img.shields.io/badge/SKY130_PDK-4B32C3?style=for-the-badge)
</div>

<br/>

## 📖 About the Project
This project is an **RTL** (Register Transfer Level) design of a custom hardware lock mechanism operating on the RISC-V architecture. To secure memory access in hardware systems requiring multiprocessing or concurrency, a custom **Atomic TAS** (Test-and-Set) instruction has been implemented at the hardware level and integrated into the system. 

The project covers a complete **RTL-to-GDSII** flow, starting from the basic hardware description (Verilog), moving through simulation processes, and ultimately generating the physical **GDSII** chip layout using the **OpenLane** flow.

---

## 🏗️ Hardware Architecture
The processor design is built with a modular approach and includes the following main modules:

| Module | Description |
| :--- | :--- |
| 🧠 **Datapath** | The main skeleton where data flow is managed and signals are routed in hardware. |
| 🎛️ **Control Unit** | The brain that decodes the **Opcode** of incoming instructions and generates the necessary control signals (e.g., `is_atomic_tas`, `is_mem_write`). |
| 🗄️ **Register File** | Temporary memory units that hold addresses and data during instruction execution. |
| 💾 **Data Memory** | A RAM module that stores lock states and handles addressing according to **Word Alignment** rules. |

---

## 🧪 Simulation & Testbench
The project includes a comprehensive **Testbench** to verify various lock scenarios. Simulations were compiled using **Icarus Verilog**, and waveforms were successfully verified.

- 🟢 **Free Lock:** Processing an incoming **Atomic TAS** request when the lock is free (`0`).
- 🔴 **Busy Lock:** Ensuring hardware safety and returning the correct state when a request arrives while the lock is already taken (`1`).
- 📝 **Normal Store:** Verifying that the system executes standard data write instructions flawlessly without interference.

---

## 🏭 Physical Implementation (RTL-to-GDSII)
The logical **RTL** codes were converted into physical silicon layouts based on the **sky130** (130nm) technology node using the **OpenLane** flow.

1. **Synthesis:** Mapping Verilog codes to **Standard Cell** libraries (NAND, Flip-Flop, etc.) using Yosys.
2. **Placement & Routing:** Defining the **Core Area**, placing hardware gates, and routing the **Wire** connections between them.
3. **Signoff & GDSII:** The final generated topology was examined on **KLayout**; the **Power Distribution Network** (PDN) and **Routing** layers were successfully visualized.

---

## 👨‍💻 Developer
**Ömer Zelka**  
*Gebze Technical University, Computer Engineering*

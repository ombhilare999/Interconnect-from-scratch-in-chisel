# Interconnect from Scratch in Chisel

- In this project, we have Implemented the Topics coverd in the Chapter 4: Interconnects of the Book [Fundamentals of System-on-Chip Design on Arm Cortex-M Microcontrollers](https://www.arm.com/resources/education/books/fundamentals-soc) by René Beuchat, Florian Depraz, Sahand Kashani, Andrea Guerrieri.
- Chapter 4 of this book covers, how interconnects can be made by scratch. These topics were Implemented in chisel in this project and verification testcases are written in Verilog.

## Project Directory Structure:

``` 
bhilare@LAPPC48:~/omkar/experiments_chisel/example_2/src$ tree -L 5
.
├── main
│   └── scala
│       └── top
│           ├── receiver
│           │   └── receiver.scala
│           ├── top.scala
│           └── transmitter
│               └── transmitter.scala
└── test
    └── scala
        └── top_test
            └── top_test.scala

8 directories, 4 files
```

## Circuit Level Representation of Top Module:
  <p align="center">
        <img width="1600" height="429" src="assets/circuit.png">
  </p>

## Final Interconnect Block Diagram:
  <p align="center">
        <img width="388" height="258" src="assets/system.png">
  </p>


## Steps:

##  **Normal Write and Read:**

> make TESTBENCH=tb_norma

### Waveform in the Book:

<p align="center">
       <img width="916" height="255" src="assets/normal_read_write.png">
</p>     

### Interconnect Output:

<p align="center">
      <img width="749" height="229" src="assets/output_normal_read_write.png">
</p>

##  **Burst Read and Write Output**

> make TESTBENCH=tb_burst

### Waveform in the Book:

<p align="center">
       <img width="893" height="269" src="assets/burst_read.png">
</p>     

<p align="center">
       <img width="805" height="273" src="assets/burst_write.png">
</p> 

### Interconnect Output:

<p align="center">
       <img width="1334" height="559" src="assets/burst_output.png">
</p> 

##  **Completer to Requestor Ready Write Example**

> make TESTBENCH=tb_ready_write

### Waveform in the Book:

<p align="center">
       <img width="883" height="330" src="assets/ready_write.png">
</p>     

### Interconnect Output:

<p align="center">
      <img width="1231" height="630" src="assets/ready_write_output.png">
</p>

##  **Completer to Requestor Ready Read Example**

> make TESTBENCH=tb_ready_read

### Waveform in the Book:

<p align="center">
       <img width="916" height="255" src="assets/ready_read.png">
</p>     

### Interconnect Output:

<p align="center">
      <img width="1240" height="558" src="assets/ready_read_output.png">
</p>

all: build-sbt testbench waveform
SBT_JAVA_OPT=-J-Xss64m -J-Xms512m -J-Xmx1024m
TESTBENCH = top_tb
WAVEFORM = top_dump

build-sbt:
	/usr/bin/sbt $(SBT_JAVA_OPT) run

testbench:
	iverilog $(TESTBENCH).v && ./a.out

waveform:
	gtkwave $(WAVEFORM).vcd

.phony : clean

clean: rm *.vcd 

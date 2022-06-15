all: build-sbt testbench waveform
SBT_JAVA_OPT=-J-Xss64m -J-Xms512m -J-Xmx1024m
TESTBENCH = top_tb
WAVEFORM = top_dump

build-sbt:
	/usr/bin/sbt $(SBT_JAVA_OPT) run

testbench:
	iverilog $(TESTBENCH).v && ./a.out

waveform:
	gtkwave -A --rcvar 'fontname_signals Monospace 12' --rcvar 'fontname_waves Monospace 12' $(WAVEFORM).vcd sample.sav

clean: 
	rm $(WAVEFORM).vcd a.out Top.v	

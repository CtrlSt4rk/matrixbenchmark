HEADERS = header.h

#compiler optimization flag
CFLAGS = -O2

all: cpufloat cpuint

cpufloat: CPUFloat.c
	gcc $(CFLAGS) CPUFloat.c -o CPUFloat.x -lm -fopenmp
	
cpuint: CPUInt.c
	gcc $(CFLAGS) CPUInt.c -o CPUInt.x -lm -fopenmp
	
clean:
	-rm -f CPUFloat.x
	-rm -f CPUInt.x

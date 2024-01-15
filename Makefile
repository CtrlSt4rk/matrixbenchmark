HEADERS = header.h

#compiler optimization flag
CFLAGS = -O2

all: cpufloat cpuint

cpufloat: CPUFloat.c
	#gcc $(CFLAGS) CPUFloat.c -o CPUFloat.x -lm -fopenmp
	clang -Xclang -fopenmp -L/opt/homebrew/opt/libomp/lib -I/opt/homebrew/opt/libomp/include -lomp $(CFLAGS) CPUFloat.c -o CPUFloat.x
	
cpuint: CPUInt.c
	#gcc $(CFLAGS) CPUInt.c -o CPUInt.x -lm -fopenmp
	clang -Xclang -fopenmp -L/opt/homebrew/opt/libomp/lib -I/opt/homebrew/opt/libomp/include -lomp $(CFLAGS) CPUInt.c -o CPUInt.x

clean:
	-rm -f CPUFloat.x
	-rm -f CPUInt.x

#example to compile with fopenmp w clang:
# clang -Xclang -fopenmp -L/opt/homebrew/opt/libomp/lib -I/opt/homebrew/opt/libomp/include -lomp omptest.c -o omptest 

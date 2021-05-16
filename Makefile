HEADERS = header.h

all: mmatriz0 mmatriz1

mmatriz0: BenchFloat.c
	gcc ${CFLAGS} BenchFloat.c -o BenchFloat -lm -fopenmp
	
mmatriz1: BenchInt.c
	gcc ${CFLAGS} BenchInt.c -o BenchInt -lm -fopenmp
	
clean:
	-rm -f BenchFloat.o
	-rm -f BenchFloat
	-rm -f BenchInt.o
	-rm -f BenchInt

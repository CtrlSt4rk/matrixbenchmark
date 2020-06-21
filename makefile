HEADERS = header.h

mmatriz: mainmultiplicamatriz.c
	gcc ${CFLAGS} mainmultiplicamatriz.c -o mmatriz -lm -fopenmp
	
clean:
	-rm -f mmatriz.o
	-rm -f mmatriz

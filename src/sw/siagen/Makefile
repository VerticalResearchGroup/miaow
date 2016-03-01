siagen: helper.cpp asm.cpp siagen.cpp main.cpp
	g++ -std=c++0x -o siagen main.cpp asm.cpp siagen.cpp helper.cpp

#main.o: main.c
#	gcc -O -Wall -c main.c

#siagen.o: siagen.c siagen.h
#	gcc -O -Wall -c siagen.c

#asm.o: asm.c asm.h
#	gcc -O -Wall -c asm.c

#helper.o: helper.c helper.h
#	gcc -O -Wall -c helper.c

#clean:
#	rm -f main.o siagen.o asm.o helper.o siagen

debug: helper.cpp asm.cpp siagen.cpp main.cpp
	g++ -ggdb -std=c++0x -o siagen main.cpp asm.cpp siagen.cpp helper.cpp

clean:
	rm -f siagen

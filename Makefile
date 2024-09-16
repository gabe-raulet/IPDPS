DEBUG?=0
D?=3
FP?=64
FLAGS=-std=c++20 -fopenmp -DDIM_SIZE=$(D) -DFP_SIZE=$(FP)
INCS=-I./misc -I./ptraits -I./mpienv -I./

ifeq ($(shell uname -s),Linux)
COMPILER=CC
MPI_COMPILER=CC
else
COMPILER=clang++
MPI_COMPILER=mpic++
endif

ifeq ($(DEBUG),1)
FLAGS+=-O0 -g -fsanitize=address -fno-omit-frame-pointer -DDEBUG
else
FLAGS+=-O2
endif

all: ptgen

.PHONY: version.h

version.h:
	@echo "#define GIT_COMMIT \"$(shell git describe --always --dirty --match 'NOT A TAG')\"" > version.h

ptgen: src/ptgen.cpp misc ptraits version.h
	$(COMPILER) -o $@ $(FLAGS) $(INCS) $<

clean:
	rm -rf ptgen version.h *.dSYM

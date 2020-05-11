CXX = g++
CXXFLAGS = -O3 -ffast-math -std=c++11
EFILE = regenie
CFLAGS = 

# specify BGEN library path (if not using the default ones below)
BGEN_PATH = 

# specify default paths based on OS
ifneq ($(strip ${BGEN_PATH}),)
	BGEN_DEFAULT_LINUX = ${BGEN_PATH}
	BGEN_DEFAULT_MAC = ${BGEN_PATH}
else
	BGEN_DEFAULT_LINUX = /mnt/efs/users/jonathan.marchini/software/bgen/
	BGEN_DEFAULT_MAC = /Users/jonathan.marchini/software/bgen/
endif

# detect OS architecture and add flags
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	BGEN = ${BGEN_DEFAULT_LINUX}
	INC = -I${BGEN}/3rd_party/boost_1_55_0
	CFLAGS += -fopenmp
endif
ifeq ($(UNAME_S),Darwin)
	BGEN = ${BGEN_DEFAULT_MAC}
	CXXFLAGS += -stdlib=libc++
endif


LPATHS = -L${BGEN}/build/ -L${BGEN}/build/3rd_party/zstd-1.1.0/ -L${BGEN}/build/db/ -L${BGEN}/build/3rd_party/sqlite3/ -L${BGEN}/build/3rd_party/boost_1_55_0 -L/usr/lib/
LIBS = -lbgen -lzstd -ldb  -lsqlite3 -lboost -lz
INC += -I${BGEN} -I${BGEN}/genfile/include/ -I${BGEN}/3rd_party/zstd-1.1.0/lib

OBJECTS = ./src/main.o  ./src/Data.o


all: ${EFILE}

${EFILE}: ${OBJECTS}
	${CXX} ${CXXFLAGS} ${CFLAGS} -o ${EFILE} ${OBJECTS} ${LPATHS} ${LIBS} 

%.o: %.cpp
	${CXX} ${CXXFLAGS} -o $@ -c $< ${INC} ${CFLAGS}

clean:
	rm -f ${EFILE} ./src/*.o

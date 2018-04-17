.PHONY=all build clean

SRCPATH=./src
TOOLS=../tools
ROM=our.nes
SRC=our.s

all: build

build: $(ROM)

$(ROM): $(SRC)
	$(TOOLS)/nesasm3 $(SRC)

clean:
	rm -f $(ROM)


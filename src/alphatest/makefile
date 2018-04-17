.PHONY=all build clean

SRCPATH=./src
TOOLS=../../tools
ROM=test.nes
SRC=test.s

all: clean build

build: $(ROM)

$(ROM): $(SRC)
	$(TOOLS)/nesasm3 $(SRC)

clean:
	rm -f $(ROM)


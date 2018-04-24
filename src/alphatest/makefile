.PHONY=all build clean

SRCPATH=./src
TOOLS=../../tools
ROM=alpha.nes
SRC=alpha.s

all: clean build

build: $(ROM)

$(ROM): $(SRC)
	$(TOOLS)/nesasm3 $^

clean:
	rm -f $(ROM)


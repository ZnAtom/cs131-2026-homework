.PHONY: all translate test clean zip

all: factorial translate

factorial:
	dune build
	cp code/main.exe factorial

translate: 
	dune build
	cp code/translate.exe translate

dev:
	dune build --watch --terminal-persistence=clear-on-rebuild

utop:
	utop

clean:
	dune clean
	rm -rf translate factorial factorial.ml

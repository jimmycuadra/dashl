.PHONY: build
build: elm-make
	cargo build

.PHONY: run
run: elm-make
	cargo run

.PHONY: deps
deps:
	elm package install

###

.PHONY: elm-make
elm-make:
	elm make src/Main.elm --warn --output js/dashboard.js

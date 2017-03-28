.PHONY: build
build:
	elm make src/Main.elm --warn --output js/dashboard.js
	cargo build

.PHONY: run
run:
	cargo run

.PHONY: deps
deps:
	elm package install

ELM_MAKE_ARGS := src/Main.elm --warn --output js/dashboard.js

.PHONY: build
build:
	elm make $(ELM_MAKE_ARGS)
	cargo build

.PHONY: serve
run:
	cargo run

.PHONY: bootstrap
bootstrap: global-deps deps

.PHONY: global-deps
global-deps:
	brew install elm

.PHONY: deps
deps:
	elm package install

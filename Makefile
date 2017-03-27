ELM_MAKE_ARGS := src/Main.elm --warn --output dist/js/dashboard.js

.PHONY: build
build: elm-make

.PHONY: dev
dev: elm-live

.PHONY: bootstrap
bootstrap: global-deps deps

.PHONY: global-deps
global-deps:
	brew install elm yarn

.PHONY: deps
deps:
	elm package install
	yarn install

.PHONY: elm-make
elm-make:
	elm make $(ELM_MAKE_ARGS)

.PHONY: elm-live
elm-live:
	./node_modules/.bin/elm-live --dir=dist --open -- $(ELM_MAKE_ARGS)

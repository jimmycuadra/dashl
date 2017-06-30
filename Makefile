.PHONY: build
build: elm-make
	cargo build

.PHONY: run
run: elm-make
	cargo run

.PHONY: deps
deps:
	elm package install --yes

.PHONY: docker-build
docker-build:  musl-build
	docker build -t jimmycuadra/dashl:$(shell git rev-parse HEAD) .

###

.PHONY: musl-build
musl-build: docker-cargo-cache
	docker run -v ${PWD}/docker-cargo-cache:/root/.cargo -v ${PWD}:/volume -w /volume --rm -it clux/muslrust cargo build --release

.PHONY: elm-make
elm-make:
	elm make elm/Main.elm --warn --output js/dashboard.js

docker-cargo-cache:
	mkdir docker-cargo-cache

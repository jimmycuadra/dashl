FROM codesimple/elm:0.18 as elm
WORKDIR /app
COPY . /app
RUN make deps
RUN make elm-make

FROM jimmycuadra/rust-armv7hf:1.18.0 as rust
RUN ["cross-build-start"]
WORKDIR /source
COPY . /source
RUN cargo build --release --jobs 1
RUN ["cross-build-end"]

FROM resin/raspberrypi3-debian
CMD ["/app/dashl"]
EXPOSE 3000
COPY --from=elm /app/index.html /app/index.html
COPY --from=elm /app/css /app/css
COPY --from=elm /app/js /app/js
COPY --from=elm /app/vendor /app/vendor
COPY --from=rust /source/target/release/dashl /app/dashl

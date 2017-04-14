FROM scratch

CMD ["/dashl"]
WORKDIR /app
EXPOSE 3000

COPY target/x86_64-unknown-linux-musl/release/dashl /dashl
COPY index.html /app/index.html
COPY css /app/css
COPY js /app/js
COPY vendor /app/vendor

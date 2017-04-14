# Dashl

**Dashl** is a dashboard app to be displayed on a Raspberry Pi kiosk I have set up in my home.
It includes the following widgets:

* Countdown timer
* Local weather

# Dependencies

* [Elm](http://www.elm-lang.org/)
* [Make](https://www.gnu.org/software/make/)
* [Rust](https://www.rust-lang.org/)

# Setup

Copy `config/config.sample.json` to `config/config.json` and fill in the values you want.
Then run:

``` bash
$ make deps
```

## Usage

Run:

``` bash
$ make run
```

This will compile the Elm and Rust code and start the server on port 3000 of all network interfaces.
Browse to http://localhost:3000/ to see it.

If you change any Elm code, run `make elm-make` to recompile it, and reload the page in your browser.
If you change any Rust code, you'll need to interrupt the server with control-C and start it again with `make run`.

## Deployment

Build a Docker image by running:

``` bash
$ make docker-build
```

Use it by running:

``` bash
$ docker run -p 3000:3000 -e SSL_CERT_FILE=/certs/cert.pem -v $CERT_DIR:/certs -v $CONFIG_DIR:/app/config jimmycuadra/dashl:$TAG
```

where:

* `$CERT_DIR` is the absolute path to a directory containing `cert.pem`, which are the CA certificates to trust
* `$CONFIG_DIR` is the absolute path to a directory containing your config.json file
* `$TAG` is whatever Docker tag was used in the build step

The server will be running on port 3000 as usual.

## Legal

Dashl is released under the MIT license.
See the attached LICENSE file.

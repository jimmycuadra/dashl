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

Copy `js/config.sample.json` to `js/config.json` and fill in the values you want.
Then run:

``` bash
$ make deps
```

## Usage

Run:

``` bash
$ make run
```

This will compile the Elm and Rust code and start the proxy server.
Then just open `index.html` in a browser!

## Legal

Dashl is released under the MIT license.
See the attached LICENSE file.

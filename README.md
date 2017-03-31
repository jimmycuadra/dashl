# Dashl

**Dashl** is a dashboard app to be displayed on a Raspberry Pi kiosk I have set up in my home.
It includes the following widgets:

* Countdown timer
* Local weather

# Build dependencies

* [Rust](https://www.rust-lang.org/)

## Usage

Copy `js/config.sample.json` to `js/config.json` and fill in the values you want.
Run `cargo run` to build and start the proxy server.
Then open `index.html` in a browser.

## Legal

Dashl is released under the MIT license.
See the attached LICENSE file.

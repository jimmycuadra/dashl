# Dashl

**Dashl** is a dashboard app to be displayed on a Raspberry Pi kiosk I have set up in my home.
The plan is to include the following widgets:

* Countdown timer
* Local weather
* Kubernetes cluster metrics
* Status of apps currently deployed to the Kubernetes cluster

## Development dependencies

* Elm Platform
* Make
* Rust

## Setup

```
$ make deps
```

## Building

```
$ make
```

## Running

```
$ make serve
$ open http://localhost:3000/
```

## Legal

Dashl is released under the MIT license.
See the attached LICENSE file.

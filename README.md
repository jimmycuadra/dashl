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

Write a config file to `config.json`:

``` json
{
  "eventName": "London trip",
  "eventTime": "23 Apr 2017 00:00:00 GMT-0700",
  "openWeatherApiKey": "862410e97da44d21e1dc17a9f3330041"
}
```

```
$ make serve
$ open http://localhost:3000/
```

## Legal

Dashl is released under the MIT license.
See the attached LICENSE file.

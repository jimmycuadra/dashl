extern crate futures;
extern crate hyper;
extern crate hyper_tls;
extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate serde_json;

use std::fs::{read, read_to_string};

use futures::future::ok;
use hyper::client::HttpConnector;
use hyper::header::{ACCESS_CONTROL_ALLOW_ORIGIN, CONTENT_TYPE};
use hyper::rt::{run, Future};
use hyper::service::service_fn;
use hyper::{Body, Client, Error, Request, Response, Server};
use hyper_tls::HttpsConnector;

#[derive(Debug, Clone, Deserialize, Serialize)]
struct Config {
    timer: TimerConfig,
    weather: WeatherConfig,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
struct TimerConfig {
    name: String,
    time: String,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
struct WeatherConfig {
    #[serde(rename = "darkSkyApiKey")]
    dark_sky_api_key: String,
    latitude: String,
    longitude: String,
    name: String,
}

#[derive(Debug, Clone)]
struct Dashl {
    config: Config,
}

fn app(
    request: Request<Body>,
    dashl: &Dashl,
    client: &Client<HttpsConnector<HttpConnector>>,
) -> Box<Future<Item = Response<Body>, Error = Error> + Send> {
    match request.uri().path() {
        "/config.json" => Box::new(ok(Response::builder()
            .header(CONTENT_TYPE, "application/json")
            .header(ACCESS_CONTROL_ALLOW_ORIGIN, "*")
            .body(Body::from(serde_json::to_vec(&dashl.config).unwrap()))
            .unwrap())),
        "/forecast" => {
            let url = format!(
                    "https://api.darksky.net/forecast/{}/{},{}?exclude=currently,minutely,hourly,alerts,flags",
                    &dashl.config.weather.dark_sky_api_key,
                    &dashl.config.weather.latitude,
                    &dashl.config.weather.longitude,
                );

            Box::new(client.get(url.parse().unwrap()).and_then(|response| {
                Ok(Response::builder()
                    .header(CONTENT_TYPE, "application/json")
                    .header(ACCESS_CONTROL_ALLOW_ORIGIN, "*")
                    .body(response.into_body())
                    .unwrap())
            }))
        }
        "/" | "index.html" => Box::new(ok(Response::builder()
            .header(CONTENT_TYPE, "text/html")
            .header(ACCESS_CONTROL_ALLOW_ORIGIN, "*")
            .body(Body::from(read("index.html").unwrap()))
            .unwrap())),
        path => {
            let mut builder = Response::builder();

            builder.header(ACCESS_CONTROL_ALLOW_ORIGIN, "*");

            let file = match read(&path[1..path.len()]) {
                Ok(file) => file,
                Err(_) => return Box::new(ok(builder.status(404).body(Body::empty()).unwrap())),
            };

            if path.ends_with(".js") {
                builder.header(CONTENT_TYPE, "application/javascript");
            } else if path.ends_with(".css") {
                builder.header(CONTENT_TYPE, "text/css");
            } else {
                return Box::new(ok(builder.status(404).body(Body::empty()).unwrap()));
            }

            Box::new(ok(builder.body(Body::from(file)).unwrap()))
        }
    }
}

fn main() {
    let config_contents =
        read_to_string("config/config.json").expect("config/config.json is missing");
    let config: Config = serde_json::from_str(&config_contents).unwrap();

    let dashl = Dashl { config: config };

    let https = HttpsConnector::new(4).unwrap();
    let client = Client::builder().build::<_, Body>(https);

    let new_service = move || {
        let client = client.clone();
        let dashl = dashl.clone();

        service_fn(move |req| app(req, &dashl, &client))
    };

    let server = Server::bind(&([0, 0, 0, 0], 3000).into())
        .serve(new_service)
        .map_err(|error| {
            eprintln!("ERROR: {}", error);
        });

    run(server);
}

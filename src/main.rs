extern crate futures;
extern crate hyper;
extern crate hyper_native_tls;
extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate serde_json;

use std::io::{self, Error as IoError, Read};
use std::fs::File;

use hyper::{Client, Server};
use hyper::header::{AccessControlAllowOrigin, ContentType};
use hyper::net::HttpsConnector;
use hyper::server::{Handler, Request, Response};
use hyper::status::StatusCode;
use hyper::uri::RequestUri;
use hyper_native_tls::NativeTlsClient;

#[derive(Clone, Deserialize, Serialize)]
struct Config {
    timer: TimerConfig,
    weather: WeatherConfig,
}

#[derive(Clone, Deserialize, Serialize)]
struct TimerConfig {
    name: String,
    time: String,
}

#[derive(Clone, Deserialize, Serialize)]
struct WeatherConfig {
    #[serde(rename = "darkSkyApiKey")]
    dark_sky_api_key: String,
    latitude: String,
    longitude: String,
    #[serde(rename = "zipCode")]
    zip_code: String,
}

#[derive(Clone)]
struct Dashl {
    config: Config,
}

impl Handler for Dashl {
    fn handle(&self, request: Request, mut response: Response) {
        if let RequestUri::AbsolutePath(path) = request.uri {
            match path.as_ref() {
                "/config.json" => {
                    {
                        let mut headers = response.headers_mut();
                        headers.set(ContentType("application/json".parse().unwrap()));
                        headers.set(AccessControlAllowOrigin::Any);
                    }

                    response.send(&serde_json::to_vec(&self.config).unwrap()).unwrap();
                }
                "/forecast" => {
                    let ssl = NativeTlsClient::new().unwrap();
                    let connector = HttpsConnector::new(ssl);
                    let client = Client::with_connector(connector);

                    let url = format!(
                        "https://api.darksky.net/forecast/{}/{},{}?exclude=currently,minutely,hourly,alerts,flags",
                        &self.config.weather.dark_sky_api_key,
                        &self.config.weather.latitude,
                        &self.config.weather.longitude,
                    );

                    let mut api_response = client.get(&url).send().unwrap();
                    *response.status_mut() = api_response.status;

                    {
                        let mut headers = response.headers_mut();
                        headers.set(ContentType("application/json".parse().unwrap()));
                        headers.set(AccessControlAllowOrigin::Any);
                    }

                    let mut streaming_response = response.start().unwrap();
                    io::copy(&mut api_response, &mut streaming_response).unwrap();
                }
                _ => *response.status_mut() = StatusCode::NotFound,
            }
        }
    }
}

fn load_file(path: &str) -> Result<String, IoError> {
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;

    Ok(contents)
}

fn main() {
    let config_contents = load_file("js/config.json").expect("config.json is missing");
    let config: Config = serde_json::from_str(&config_contents).unwrap();

    let dashl = Dashl {
        config: config,
    };

    let server = Server::http("127.0.0.1:3000").unwrap();
    let _guard = server.handle(dashl);
    println!("Listening on http://127.0.0.1:3000");
}

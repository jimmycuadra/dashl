#[macro_use]
extern crate askama;
extern crate futures;
extern crate hyper;
extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate serde_json;

use std::io::{Error as IoError, Read};
use std::fs::File;
use std::net::{Ipv4Addr, SocketAddr, SocketAddrV4};

use askama::Template;
use futures::future::{FutureResult, ok};
use hyper::Error as HyperError;
use hyper::header::ContentType;
use hyper::server::{Http, Request, Response, Service};
use hyper::status::StatusCode;

#[derive(Deserialize, Serialize)]
struct Config {
    #[serde(rename = "eventName")]
    event_name: String,
    #[serde(rename = "eventTime")]
    event_time: String,
    #[serde(rename = "openWeatherApiKey")]
    open_weather_map_api_key: String,
}

#[derive(Template)]
#[template(path = "index.html")]
struct IndexHtml {
    config: String,
}

#[derive(Clone)]
struct Dashl {
    index_html: String,
}

impl Service for Dashl {
    type Request = Request;
    type Response = Response;
    type Error = HyperError;
    type Future = FutureResult<Response, HyperError>;

    fn call(&self, request: Self::Request) -> Self::Future {
        match request.path() {
            "/" | "/index.html" => {
                ok(
                    Response::new()
                        .with_header(ContentType("text/html".parse().unwrap()))
                        .with_body(self.index_html.clone())
                )
            }
            path => {
                match load_file(&path[1..path.len()]) {
                    Ok(file) => {
                        let content_type = if path.ends_with(".css") {
                            "text/css".parse().unwrap()
                        } else if path.ends_with(".js") {
                            "text/js".parse().unwrap()
                        } else {
                            "application/octet-stream".parse().unwrap()
                        };

                        ok(
                            Response::new()
                                .with_header(ContentType(content_type))
                                .with_body(file)
                        )
                    }
                    Err(_) => ok(Response::new().with_status(StatusCode::NotFound)),
                }
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
    let config_contents = load_file("config.json").expect("config.json is missing");
    let config: Config = serde_json::from_str(&config_contents).unwrap();
    let template = IndexHtml { config: serde_json::to_string(&config).unwrap() };
    let index_html = template.render();

    let dashl = Dashl {
        index_html: index_html,
    };

    let ip_address = Ipv4Addr::new(127, 0, 0, 1);
    let socket_address_v4 = SocketAddrV4::new(ip_address, 3000);
    let socket_address = SocketAddr::V4(socket_address_v4);
    let server = Http::new().bind(&socket_address, move || Ok(dashl.clone())).unwrap();

    server.run().unwrap();
}

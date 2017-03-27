#[macro_use]
extern crate askama;
extern crate futures;
extern crate hyper;
extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate serde_json;

use std::io::Read;
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
    css_dashboard_css: String,
    index_html: String,
    js_dashboard_js: String,
    vendor_css_bootstrap_min_css: String,
    vendor_js_bootstrap_min_js: String,
    vendor_js_jquery_3_2_0_slim_min_js: String,
    vendor_js_tether_1_4_0_min_js: String,
}

impl Service for Dashl {
    type Request = Request;
    type Response = Response;
    type Error = HyperError;
    type Future = FutureResult<Response, HyperError>;

    fn call(&self, request: Self::Request) -> Self::Future {
        match request.path() {
            "/css/dashboard.css" => {
                ok(
                    Response::new()
                        .with_header(ContentType("text/css".parse().unwrap()))
                        .with_body(self.css_dashboard_css.clone())
                )
            }
            "/" | "/index.html" => {
                ok(
                    Response::new()
                        .with_header(ContentType("text/html".parse().unwrap()))
                        .with_body(self.index_html.clone())
                )
            }
            "/js/dashboard.js" => {
                ok(
                    Response::new()
                        .with_header(ContentType("text/javascript".parse().unwrap()))
                        .with_body(self.js_dashboard_js.clone())
                )
            }
            "/vendor/css/bootstrap.min.css" => {
                ok(
                    Response::new()
                        .with_header(ContentType("text/css".parse().unwrap()))
                        .with_body(self.vendor_css_bootstrap_min_css.clone())
                )
            }
            "/vendor/js/bootstrap.min.js" => {
                ok(
                    Response::new()
                        .with_header(ContentType("text/javascript".parse().unwrap()))
                        .with_body(self.vendor_js_bootstrap_min_js.clone())
                )
            }
            "/vendor/js/jquery-3.2.0.slim.min.js" => {
                ok(
                    Response::new()
                        .with_header(ContentType("text/javascript".parse().unwrap()))
                        .with_body(self.vendor_js_jquery_3_2_0_slim_min_js.clone())
                )
            }
            "/vendor/js/tether-1.4.0.min.js" => {
                ok(
                    Response::new()
                        .with_header(ContentType("text/javascript".parse().unwrap()))
                        .with_body(self.vendor_js_tether_1_4_0_min_js.clone())
                )
            }
            _ => {
                ok(Response::new().with_status(StatusCode::Ok))
            }
        }
    }
}

fn load_file(path: &str) -> String {
    let mut file = File::open(path).unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();

    contents
}

fn main() {
    let config_contents = load_file("config.json");
    let config: Config = serde_json::from_str(&config_contents).unwrap();
    let template = IndexHtml { config: serde_json::to_string(&config).unwrap() };
    let index_html = template.render();

    let dashl = Dashl {
        css_dashboard_css: load_file("dist/css/dashboard.css"),
        index_html: index_html,
        js_dashboard_js: load_file("dist/js/dashboard.js"),
        vendor_css_bootstrap_min_css: load_file("dist/vendor/css/bootstrap.min.css"),
        vendor_js_bootstrap_min_js: load_file("dist/vendor/js/bootstrap.min.js"),
        vendor_js_jquery_3_2_0_slim_min_js: load_file("dist/vendor/js/jquery-3.2.0.slim.min.js"),
        vendor_js_tether_1_4_0_min_js: load_file("dist/vendor/js/tether-1.4.0.min.js"),
    };

    let ip_address = Ipv4Addr::new(127, 0, 0, 1);
    let socket_address_v4 = SocketAddrV4::new(ip_address, 3000);
    let socket_address = SocketAddr::V4(socket_address_v4);
    let server = Http::new().bind(&socket_address, move || Ok(dashl.clone())).unwrap();

    server.run().unwrap();
}

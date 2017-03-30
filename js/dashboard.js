!(function (exports, undefined) {
  function Dashl(config) {
    document.getElementById('timer-event-name').innerHTML = config.eventName;

    this.timer = {
      days: document.getElementById('timer-event-days'),
      hours: document.getElementById('timer-event-hours'),
      mins: document.getElementById('timer-event-mins'),
      secs: document.getElementById('timer-event-secs'),
    };

    this.timer.countdown = countdown(
      Date.parse('23 Apr 2017 00:00:00 GMT-0700'),
      this.updateTimer.bind(this),
      countdown.DAYS | countdown.HOURS | countdown.MINUTES | countdown.SECONDS
    );

    this.weather = {
      element: document.getElementById('weather'),

      countryCode: config.countryCode,
      openWeatherMapApiKey: config.openWeatherMapApiKey,
      zipCode: config.zipCode,

      interval: setInterval(this.getWeather.bind(this), 900000) // 15 minutes
    };

    this.getWeather();
  }

  Dashl.prototype.getWeather = function () {
    let request = new XMLHttpRequest();

    request.open(
      'GET',
      'http://api.openweathermap.org/data/2.5/forecast?units=imperial&zip=' +
        this.weather.zipCode + ',' + this.weather.countryCode +
        '&appid=' + this.weather.openWeatherMapApiKey,
      true
    );

    request.onload = function() {
      if (request.status >= 200 && request.status < 400) {
        let data = JSON.parse(request.responseText);

        this.renderWeather(data);
      } else {
        console.log(request);
      }
    }.bind(this);

    request.onerror = function() {
      console.log('Connection error');
    };

    request.send();
  };

  Dashl.prototype.renderForecast = function (forecast, parentElement) {
    let element = document.createElement('p');
    element.innerHTML = moment(forecast.dt_txt).calendar() +
      "<br/>" + forecast.main.temp + "&deg;F (" + forecast.weather[0].description + ")";
    parentElement.prepend(element);
  }

  Dashl.prototype.renderWeather = function (data) {
    let forecasts = data.list.length;
    let i;
    let weather1 = document.getElementById('weather-1');
    let weather2 = document.getElementById('weather-2');
    let weather3 = document.getElementById('weather-3');
    let weather4 = document.getElementById('weather-4');
    let weather5 = document.getElementById('weather-5');

    for (i = forecasts - 1; i > forecasts - 9; i--) {
      this.renderForecast(data.list[i], weather5);
    }

    for (i = forecasts - 9; i > forecasts - 17; i--) {
      this.renderForecast(data.list[i], weather4);
    }

    for (i = forecasts - 17; i > forecasts - 25; i--) {
      this.renderForecast(data.list[i], weather3);
    }

    for (i = forecasts - 25; i > forecasts - 33; i--) {
      this.renderForecast(data.list[i], weather2);
    }

    for (i = forecasts - 33; i > 0; i--) {
      this.renderForecast(data.list[i], weather1);
    }
  };

  Dashl.prototype.updateTimer = function (timespan) {
    this.timer.days.innerHTML = timespan.days;
    this.timer.hours.innerHTML = timespan.hours;
    this.timer.mins.innerHTML = timespan.minutes;
    this.timer.secs.innerHTML = timespan.seconds;
  };

  exports.Dashl = Dashl;
})(window);

function ready(fn) {
  if (document.readyState != 'loading'){
    fn();
  } else {
    document.addEventListener('DOMContentLoaded', fn);
  }
}

!(function (exports, undefined) {
  function Dashl(config) {
    document.getElementById('timer-event-name').innerHTML = config.timer.name;
    document.getElementById('weather-zip-code').innerHTML = config.weather.zipCode;

    this.timer = {
      days: document.getElementById('timer-event-days'),
      hours: document.getElementById('timer-event-hours'),
      mins: document.getElementById('timer-event-mins'),
      secs: document.getElementById('timer-event-secs'),
      time: config.timer.time
    };

    this.weather = {
      darkSkyApiKey: config.weather.darkSkyApiKey,
      element: document.getElementById('weather-values'),
      latitude: config.weather.latitude,
      longitude: config.weather.longitude,
    };
  }

  Dashl.prototype.start = function () {
    this.timer.countdown = countdown(
      Date.parse(this.timer.time),
      this.updateTimer.bind(this),
      countdown.DAYS | countdown.HOURS | countdown.MINUTES | countdown.SECONDS
    );

    this.weather.interval = setInterval(this.getWeather.bind(this), 3600000); // 1 hour
    this.getWeather();
  };

  Dashl.prototype.getWeather = function () {
    let request = new XMLHttpRequest();

    request.open('GET', 'http://localhost:3000/forecast', true);

    request.onload = function() {
      if (request.status >= 200 && request.status < 400) {
        let data = JSON.parse(request.responseText);

        this.renderWeather(data);
      } else {
        console.error(request);
      }
    }.bind(this);

    request.onerror = function(event) {
      console.error('Connection error', event);
    };

    request.send();
  };

  Dashl.prototype.renderForecast = function (forecast, index) {
    if (index !== 0 && index % 4 == 0) {
      let breaker = document.createElement('div');
      breaker.classList.add('w-100');
      this.weather.element.appendChild(breaker);
    }

    let col = document.createElement('div');
    col.classList.add('col');

    let elements = [];

    if (typeof forecast.time != 'undefined') {
      let day = document.createElement('h5');
      day.innerHTML = moment.unix(forecast.time).format('dddd, M/D');
      elements.push(day);
    }

    if (
      typeof forecast.temperatureMax != 'undefined' && typeof forecast.temperatureMin != 'undefined'
    ) {
      let temperatures = document.createElement('p');
      temperatures.innerHTML = forecast.temperatureMax + '&deg;F high<br />' +
        forecast.temperatureMin + '&deg;F low';
      elements.push(temperatures);
    }

    elements.forEach(function (element) {
      col.appendChild(element);
    }.bind(this));

    this.weather.element.appendChild(col);
  }

  Dashl.prototype.renderWeather = function (data) {
    let forecasts = data && data.daily && data.daily.data;

    if (typeof forecasts === 'undefined') {
      console.log('No daily forecasts were present in the response.');

      return;
    }

    this.weather.element.innerHTML = '';

    forecasts.forEach(function (forecast, index) {
      this.renderForecast(forecast, index);
    }.bind(this));
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

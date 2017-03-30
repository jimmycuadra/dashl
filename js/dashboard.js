!(function (exports, undefined) {
  function App(config) {
    this.timer = {
      days: document.getElementById('timer-event-days'),
      hours: document.getElementById('timer-event-hours'),
      mins: document.getElementById('timer-event-mins'),
      secs: document.getElementById('timer-event-secs'),
    };

    this.countryCode = config.countryCode;
    this.eventTime = countdown(
      Date.parse("23 Apr 2017 00:00:00 GMT-0700"),
      this.updateTimer.bind(this),
      countdown.DAYS | countdown.HOURS | countdown.MINUTES | countdown.SECONDS
    );
    this.openWeatherMapApiKey = config.openWeatherMapApiKey;
    this.zipCode = config.zipCode;
  }

  App.prototype.updateTimer = function (timespan) {
    this.timer.days.innerHTML = timespan.days;
    this.timer.hours.innerHTML = timespan.hours;
    this.timer.mins.innerHTML = timespan.minutes;
    this.timer.secs.innerHTML = timespan.seconds;
  };

  exports.App = App;
})(window);

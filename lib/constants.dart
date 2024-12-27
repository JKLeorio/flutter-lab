
class Constants {

  static const weatherApiBaseUrl = 'http://api.open-meteo.com/v1/forecast';
  static const currentWeatherApiUrl = '';
  static const ForecastWeatherApiUrl = '';


  static const PositionDataApiUrl = 'http://nominatim.openstreetmap.org/';
  static const PositionDataApiKeys = {
    'name' : {
      'name' : 'search',
      'params' : {
        'latitude':'lat',
        'longtitude':'lot'
      }
    },
    'position' : {
      'name': 'reverse',
      'params': {
        'request' : 'q'
      }
    }
  };

  static const weather_api_keys = <String, String>{
    'temperature':'temperature_2m',
    'current':'temperature_2m,rain,weather_code',
    'hourly':'temperature_2m,weather_code&forecast_days=7',
    'format' : 'json'
  };


  static const appLogo = '';
}
import 'package:weather_forecast/constants.dart';

class CurrentWeather {


  final String cityName;
  final double latitude;
  final double longitude;
  final String timezone;
  final DateTime time;
  final int interval;
  final double temperature;
  final double elevation;
  final Map<String, dynamic> current_data_format;
  final Map<String, dynamic> current_data;

  CurrentWeather({
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.time,
    required this.interval,
    required this.temperature,
    required this.elevation,
    required this.current_data_format,
    required this.current_data,
  });

  factory CurrentWeather.fromJson(String cityName ,Map<String, dynamic> json){
    return CurrentWeather(
        cityName: cityName,
        latitude : json['latitude'],
        longitude : json['longitude'],
        timezone : json['timezone'],
        elevation : json['elevation'],
        time : DateTime.parse(json['current']['time']),
        interval : json['current']['interval'],
        temperature : json['current'][Constants.weather_api_keys['temperature']],
        current_data_format: json['current_units'],
        current_data: json['current'],
    );
  }
}

class HourlyWeather extends CurrentWeather {


  final Map<String, dynamic> hourly_data_format;
  final Map<String, dynamic>  hourly_data;


  HourlyWeather({
    required super.cityName,
    required super.latitude,
    required super.longitude,
    required super.timezone,
    required super.time,
    required super.interval,
    required super.temperature,
    required super.elevation,
    required super.current_data_format,
    required super.current_data,
    required this.hourly_data_format,
    required this.hourly_data,
  });

  factory HourlyWeather.fromJson(String cityName, Map<String, dynamic> json){
    return HourlyWeather(
        cityName: cityName,
        latitude : json['latitude'],
        longitude : json['longitude'],
        timezone : json['timezone'],
        elevation : json['elevation'],
        time : DateTime.parse(json['current']['time']),
        interval : json['current']['interval'],
        temperature : json['current'][Constants.weather_api_keys['temperature']],
        current_data_format: json['current_units'],
        current_data: json['current'],
        hourly_data_format: json['hourly_units'],
        hourly_data: json['hourly']
    );
  }
}
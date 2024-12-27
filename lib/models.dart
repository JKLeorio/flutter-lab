import 'package:intl/intl.dart';
import 'package:weather_forecast/constants.dart';
import 'package:weather_forecast/service.dart';

import 'utils.dart';

class CurrentWeather {


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

  factory CurrentWeather.fromJson(Map<String, dynamic> json){
    return CurrentWeather(
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

class HourlyWeather {

  final double latitude;
  final double longitude;
  final String timezone;
  final double elevation;
  final Map<String, dynamic> hourly_data_format;
  final Map<String, dynamic>  hourly_data;


  HourlyWeather({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.elevation,
    required this.hourly_data_format,
    required this.hourly_data,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json){
    return HourlyWeather(
        latitude : json['latitude'],
        longitude : json['longitude'],
        timezone : json['timezone'],
        elevation : json['elevation'],
        hourly_data_format: json['hourly_units'],
        hourly_data: json['hourly']
    );
  }
}

class Report {
  HourlyReport hourly;
  DailyReport daily;
  String cityName;

  Report({required this.hourly, required this.daily, required this.cityName});
}

Future<Report>? getReport() async {
  Future<HourlyReport> hourly = getHourlyReport();
  return Report(hourly: await hourly, daily: await getDailyReport(hourly), cityName: await getCityName());
}

class HourlyReport {
  List<String> hours;
  List<double> temperatures;
  List<String> imageName;

  HourlyReport({required this.hours, required this.temperatures, required this.imageName});
}


Future<String> getCityName() async {
  Map<String?, dynamic>? thePosition = await position;
  return thePosition?['city'];
}


Future<HourlyReport> getHourlyReport() async {
  Map<String?, dynamic>? thePosition = await position;
  HourlyWeather weather = await WeatherService.getHourlyWeather(latitude: thePosition?['latitude'], longitude: thePosition?['longitude']);
  Map<String, dynamic> hourly = weather.hourly_data;
  List<String> images = [];
  List<String> hours = [];
  for(int i=0; i < hourly['weather_code'].length; i++){
    hours.add(timeToLocal(DateTime.parse(hourly['time'][i]))!.toIso8601String());
    images.add(getWeatherImage(hourly['weather_code'][i]));
  }
  return HourlyReport(
      hours: new List<String>.from(hourly['time']),
      temperatures: new List<double>.from(hourly[Constants.weather_api_keys['temperature']]),
      imageName: images
  );
}


class DailyReport {
  List<int> days;
  List<double> temperatures;
  List<String> imageName;

  DailyReport({required this.days, required this.temperatures, required this.imageName});
}

Future<DailyReport> getDailyReport(Future<HourlyReport> hourlyF) async {
  HourlyReport hourly = await hourlyF;
  DateTime now = DateTime.now();
  List<double> temperatures = [];
  List<int> days = [];
  List<String> images = [];
  int current_time_unit = 0;

  for(int i = 0; hourly.hours.length > i; i++) {
    DateTime? hourlyUnit = DateTime.parse(hourly.hours[i]);
      if (now.hour == hourlyUnit.hour) {
        current_time_unit = i;
        days.add(hourlyUnit.day);
        temperatures.add(hourly.temperatures[current_time_unit]);
        images.add(hourly.imageName[i]);
      }
    }

  return DailyReport(
    days: days,
    temperatures: temperatures,
    imageName: images,
  );
}

updateLocalPosition() async{
  position = WeatherService.getCurrentPosition();
}

Future<Map<String?, dynamic>>? position = WeatherService.getCurrentPosition();
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weather_forecast/services/Weather_service.dart';

import 'package:weather_forecast/models/Weather_model.dart';

import 'package:weather_forecast/constants.dart';


String getWeatherAnimation(int? weatherCode){
  String result = 'sunshine.png';
  switch(weatherCode) {
    case 1||2||3: result = 'cloudy.png';
    case 45||48||51||53||55||56||57||71||73||75||77||85||86: result = 'snowfall.png';
    case 61||63||65||66||67||80||81||82: result = 'rain.png';
    case 95||96||99: result = 'thunder.png';
  }
  return 'assets/$result';
}

DateTime? timeToLocal(DateTime? time) {
  if(time != null) {
    time = time.add(DateTime
        .now()
        .timeZoneOffset);
  }
  return time;
}

String formatTime(DateTime? time) {
  DateTime? local_time = timeToLocal(time);
  if(local_time != null) {
    return DateFormat.yMd().add_jm().format(local_time);
  }
  return 'data is loading';
}

String getTemperature(double? temperature, String? temperatureUnit){
  if(temperature != null){
    return '$temperature $temperatureUnit';
  }
  return 'Is loading';
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key, required this.title});
  final String title;

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {

  final _weatherService = WeatherService();
  HourlyWeather? _weather;

  _fetchWeather() async {
    Map<String?, dynamic> position = await _weatherService.getCurrentPosition();

    try {
      final weather = await _weatherService.getHourlyWeather(
          cityName : position['city'],
          latitude: position['latitude'],
          longitude: position['longitude']
      );
      setState(() {
        _weather = weather;
      });
    }
    catch(e) {
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  getWeatherAnimation(_weather?.current_data["weather_code"])
              ),
            ),
            Text(
              _weather?.cityName ?? "loading city..",
              style: TextStyle(
                color : Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              )),
            Text(
                formatTime(_weather?.time),
                style: TextStyle(
                  color : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                )
            ),
            Text(getTemperature(_weather?.temperature ,_weather?.current_data_format[
              Constants.weather_api_keys['temperature']
            ]),
              style: TextStyle(
                  color : Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w700
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 30, left: 30, top: 30),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Image.asset('assets/cloudy.png', scale: 8,)
                ),
                SizedBox(
                    child: Image.asset('assets/rain.png', scale: 8,)
                ),
                SizedBox(
                    child: Image.asset('assets/snowfall.png', scale: 8,)
                ),
                SizedBox(
                    child: Image.asset('assets/thunder.png', scale: 8,)
                ),
              ],
            ))
          ],
        ),
      )
    );
  }

}

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_forecast/models.dart';
import 'dart:convert';
import 'package:weather_forecast/constants.dart';


class WeatherService {
  static const String BASE_URL = Constants.weatherApiBaseUrl;
  static const Map<String, String> api_keys = Constants.weather_api_keys;

  static Future<Map<String?, dynamic>> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if( permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    else if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);

    Map<String?, dynamic> result =  {
      'city' : placemark[0].locality,
      'latitude': position.latitude,
      'longitude' : position.longitude
    };

    return result;
  }


  static Future<CurrentWeather> getCurrentWeather({required double latitude,required double longitude})
  async {
    final path = '$BASE_URL?latitude=$latitude&longitude=$longitude&current=${api_keys['current']}&format=${api_keys['format']}';
    final response = await http.get(
        Uri.parse(
            path
        )
    );
    if(response.statusCode == 200){
      return CurrentWeather.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Failed to load weather data \n path - $path \n status code - ${response.statusCode} \n body - ${response.body}');
    }
  }


  static Future<HourlyWeather> getHourlyWeather({cityName ,required double latitude,required double longitude})
  async {
    final path = '$BASE_URL?latitude=$latitude&longitude=$longitude&hourly=${api_keys['hourly']}&format=${api_keys['format']}';
    final response = await http.get(
        Uri.parse(
            path
        )
    );
    if(response.statusCode == 200){
      return HourlyWeather.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Failed to load weather data \n path - $path \n status code - ${response.statusCode} \n body - ${response.body}');
    }
  }


  Future<HourlyWeather> getFullWeather({required double latitude,required double longitude})
  async {
    final path = '$BASE_URL?latitude=$latitude&longitude=$longitude&current=${api_keys['current']}&hourly=${api_keys['hourly']}&format=${api_keys['format']}';
    final response = await http.get(
        Uri.parse(
            path
        )
    );
    if(response.statusCode == 200){
      return HourlyWeather.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Failed to load weather data \n path - $path \n status code - ${response.statusCode} \n body - ${response.body}');
    }
  }
}

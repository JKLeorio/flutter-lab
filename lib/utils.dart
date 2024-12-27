import 'package:intl/intl.dart';

const SUNSHINE = "sunshine.png";
const CLOUDY = 'cloudy.png';
const SNOWFALL = 'snowfall.png';
const THUNDER = 'thunder.png';
const RAIN = 'rain.png';



String getWeatherImage(int? weatherCode){
  String result = SUNSHINE;
  switch(weatherCode) {
    case 1||2||3: result = CLOUDY;
    case 45||48||51||53||55||56||57||71||73||75||77||85||86: result = SNOWFALL;
    case 61||63||65||66||67||80||81||82: result = RAIN;
    case 95||96||99: result = THUNDER;
  }
  return 'assets/$result';
}


// _fetchWeather() async {
//   Map<String?, dynamic> position = await _weatherService.getCurrentPosition();
//
//   try {
//     final weather = await _weatherService.getHourlyWeather(
//         cityName : position['city'],
//         latitude: position['latitude'],
//         longitude: position['longitude']
//     );
//     setState(() {
//       _weather = weather;
//     });
//   }
//   catch(e) {
//     print(e);
//     Fluttertoast.showToast(msg: e.toString());
//   }
// }

String FormatDateTime(String data) {

  // Parse the string into a DateTime object
  DateTime parsedDateTime = DateTime.parse(data);

  // Format the DateTime object to "HH:mm"
  String formattedTime = DateFormat('HH:mm').format(parsedDateTime);
  return formattedTime;
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

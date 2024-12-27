import 'package:flutter/material.dart';
import 'package:weather_forecast/models.dart';
import 'package:weather_forecast/utils.dart';


class WeatherHomePage extends StatefulWidget {
  WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  @override
  Widget build(BuildContext context) {
      return FutureBuilder<Report>(
        future: getReport(),
        builder: (context, AsyncSnapshot<Report> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          else if (snapshot.hasData) {
            var data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                
                    Text("температура сейчас:", style: TextStyle(fontSize: 30),),
                    Image.asset(snapshot.data!.daily.imageName[0], scale: 3,),
                
                    SizedBox(height: 20,),
                    Text(snapshot.data!.cityName, style: TextStyle(fontSize: 50)),
                    Text(snapshot.data!.daily.temperatures[0].toString() + "C*", style: TextStyle(fontSize: 40),),
                
                    SizedBox(height: 20,),
                
                    Divider(),
                
                    Text("почасово", style: TextStyle(fontSize: 30),),
                
                    SizedBox(
                      width: 1200,
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.hourly.temperatures.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(data.hourly.imageName[index], scale: 10,),
                                  Text(data.hourly.temperatures[index].toString(), style: TextStyle(fontSize: 40)),
                                  Text(FormatDateTime(data.hourly.hours[index])),
                                ],
                              ),
                            );
                          }
                      ),
                    ),
                
                    Divider(),
                    Text("За эту неделю", style: TextStyle(fontSize: 30),),
                
                    SizedBox(
                      width: 1200,
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.daily.temperatures.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(data.daily.imageName[index], scale: 10,),
                                  Text(data.daily.temperatures[index].toString(), style: TextStyle(fontSize: 40)),
                                  Text(data.daily.days[index].toString())
                                ],
                              ),
                            );
                          }
                      ),
                    ),
                  ]
                ),
              ),
            );
          } else {
            return Center(child: Text("is loading..."));
          }
        }
      );
  }
}

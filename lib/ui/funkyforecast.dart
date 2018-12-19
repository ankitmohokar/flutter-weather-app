import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../ui/changecity.dart';
import '../utils/utils.dart' as utils;
import 'package:http/http.dart' as http;

class FunkyForecast extends StatefulWidget {
  @override
  _FunkyForecastState createState() => _FunkyForecastState();
}

class _FunkyForecastState extends State<FunkyForecast> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator
        .of(context)
        .push(MaterialPageRoute<Map>(builder: (BuildContext context) {
          return ChangeCity();
    }));

    if (results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];
    }

  }

  void showWeather() async {
    Map data = await getWeather(utils.appId, '$_cityEntered');
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forecastor'),
        backgroundColor: Colors.lightBlueAccent ,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {_goToNextScreen(context);})
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/umbrella.png', height: 900.0 ,fit: BoxFit.fill),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 11.0, 21.0, 0.0),
            child: Text('${_cityEntered == null ? utils.defaultCity : _cityEntered }', style: cityStyle(),),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),
          // This will eventually have the dynamic data from OpenWeatherMap
          Container(
            margin: const EdgeInsets.fromLTRB(30.0, 490.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered)
          )
        ],
      ),
    );
  }
  Future<Map> getWeather(String appId, String city) async {
    String apiURL = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${utils.appId}&units=imperial';
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future: getWeather(utils.appId, city == null ? utils.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          // where we get the json data, set up widgets, etc
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Temperature: " + (((content['main']['temp'])-32)*0.55).round().toString() + "°C",
                    style: tempStyle())
                  ),
                  ListTile(
                      title: Text("Today's High: " + (((content['main']['temp_max'])-32)*0.55).round().toString() + "°C",
                          style: forecastStyle())
                  ),
                   ListTile(
                      title: Text("Today's Low: " + (((content['main']['temp_min'])-32)*0.55).round().toString() + "°C",
                          style: forecastStyle())
                  )
                ],
              )
            );
          } else {
            return Container();
          }
    });
  }
}

TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 23.0,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 30.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );
}

TextStyle forecastStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );
}

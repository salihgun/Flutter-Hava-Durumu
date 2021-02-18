import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterhavadurumu/search_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city, nullCity;
  int temperature;
  String cover = "c";
  var woeid;
  var temperatureData;
  Position position;
  List<String> dayIconsData = List(6);
  List<int> dayTemperatureData = List(6);
  List<String> dayDateData = List(6);

  Future<void> getDevicePosition() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getLocationData() async {
    var locationData = await http
        .get("https://www.metaweather.com/api/location/search/?query=$city");
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]["woeid"];
  }

  Future<void> getLocationDataLatLong() async {
    var locationData = await http.get(
        "https://www.metaweather.com/api/location/search/?lattlong=${position.latitude},${position.altitude}");
    var locationDataParsed = jsonDecode(locationData.body);
    woeid = locationDataParsed[0]["woeid"];
    city = locationDataParsed[0]["title"];
    nullCity = locationDataParsed[0]["title"];
  }

  Future<void> getTemperatureData() async {
    var response =
        await http.get("https://www.metaweather.com/api/location/$woeid/");
    var temperatureDataParsed = jsonDecode(response.body);

    setState(() {
      temperature =
          temperatureDataParsed["consolidated_weather"][0]["the_temp"].round();
      cover = temperatureDataParsed["consolidated_weather"][0]
          ["weather_state_abbr"];

      for (int i = 0; i < dayIconsData.length; i++) {
        dayIconsData[i] = temperatureDataParsed["consolidated_weather"][i]
            ["weather_state_abbr"];
        dayTemperatureData[i] = temperatureDataParsed["consolidated_weather"][i]
                ["the_temp"]
            .round();
        dayDateData[i] =
            temperatureDataParsed["consolidated_weather"][i]["applicable_date"];
      }
    });
  }

  Future<void> getDataFromAPI() async {
    await getDevicePosition(); // cihazdan konum bilgisini çekiyor
    await getLocationDataLatLong(); //lat ve long ile woeid bilgsini cekiyoruz
    getTemperatureData(); // woeid bilgisi ilen tempetarure verisi çekilior
  }

  Future<void> getDataFromAPIbyCity() async {
    await getLocationData(); // cihazdan konum bilgisini çekiyor
    getTemperatureData(); // woeid bilgisi ilen tempetarure verisi çekilior
  }

  @override
  void initState() {
    // TODO: implement initState
    getDataFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/$cover.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: temperature == null
          ? SpinKitFadingCircle(
              color: Colors.white,
              size: 50,
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: Image.network(
                          "https://www.metaweather.com/static/img/weather/png/$cover.png"),
                    ),
                    Text(
                      "$temperature C",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          shadows: [
                            Shadow(
                                color: Colors.black45,
                                blurRadius: 5,
                                offset: Offset(-3, 3))
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$city",
                          style: TextStyle(fontSize: 30, shadows: [
                            Shadow(
                                color: Colors.black45,
                                blurRadius: 5,
                                offset: Offset(-3, 3))
                          ]),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            city = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPage(),
                                ));
                            city == null ? city = nullCity : city = city;
                            getDataFromAPIbyCity();
                            setState(() {});
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dayTemperatureData.length,
                        itemBuilder: (context, index) {
                          return DailyWeather(
                            tempData: dayTemperatureData[index],
                            dateTime: dayDateData[index],
                            iconData: dayIconsData[index],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class DailyWeather extends StatelessWidget {
  final int tempData;
  final String dateTime;
  final String iconData;

  const DailyWeather({Key key, this.iconData, this.dateTime, this.tempData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> weekdays = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar"
    ];

    String weekday = weekdays[DateTime.parse(dateTime).weekday - 1];
    return Card(
      color: Colors.transparent,
      elevation: 2,
      child: Container(
        height: 120,
        width: 120,
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              child: Image.network(
                  "https://www.metaweather.com/static/img/weather/png/$iconData.png"),
            ),
            Text(
              "$tempData C",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                        color: Colors.black45,
                        blurRadius: 5,
                        offset: Offset(-3, 3))
                  ]),
            ),
            Text(
              "$weekday",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                        color: Colors.black45,
                        blurRadius: 5,
                        offset: Offset(-3, 3))
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

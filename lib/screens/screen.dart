import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../services/location_service.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String getWeatherIcon(String condition) {
    condition = condition.toLowerCase();

    if (condition.contains('cloud')) {
      return Twemoji.cloud;
    } else if (condition.contains('sun')) {
      return Twemoji.sun;
    } else if (condition.contains('rain')) {
      return Twemoji.cloud_with_rain;
    } else if (condition.contains('snow')) {
      return Twemoji.snowflake;
    } else if (condition.contains('storm') || condition.contains('thunder')) {
      return Twemoji.cloud_with_lightning_and_rain;
    } else if (condition.contains('clear')) {
      return Twemoji.sun;
    } else {
      return Twemoji.sun_behind_cloud; // default icon
    }
  }

  String weatherEmoji = Twemoji.sun_behind_cloud;
  String cityName = 'New York';
  String temp = '22';
  String condition = 'Sunny';

  void handleLocation() async {
    final position = await LocationService.getCurrentLocation();

    if (position != null) {
      final weatherService = WeatherService();
      final weatherData = await weatherService.getData(position.latitude, position.longitude);

      if (weatherData != null) {
        setState(() {
          cityName = weatherData['city'];
          temp = weatherData['temp'].toString();
          condition = weatherData['condition'];
          weatherEmoji = getWeatherIcon(condition);
        });
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue, size: 26),
                    const SizedBox(width: 7),
                    Text(
                      cityName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Iconify(weatherEmoji, size: 80),
                          SizedBox(width: 8),
                          Text(
                            condition,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            temp,
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            ' °c',
                            style: TextStyle(
                              fontSize: 70,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 200),
                      ElevatedButton(
                        onPressed: handleLocation,
                        child: const Text(
                          'Get Location',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

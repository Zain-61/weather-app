import 'dart:convert';
import 'package:http/http.dart' as http;




class WeatherService {
  Future<Map<String, dynamic>?> getData(double lat, double lon) async {
    final String apiKey = '93a5cca0e3msha9316d5a1fb7c04p1c07b2jsnba1fbd231903';
    final String apiHost = 'weatherbit-v1-mashape.p.rapidapi.com';

    final Uri url = Uri.https(apiHost, '/forecast/3hourly', {
      'lat': lat.toString(),
      'lon': lon.toString(),
    });

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': apiHost,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final firstForecast = data['data'][0];

      return {
        'temp': firstForecast['temp'],
        'condition': firstForecast['weather']['description'],
        'city': data['city_name'],
      };
    } else {
      print('Failed to load weather data. Status code: ${response.statusCode}');
      return null;
    }
  }
}

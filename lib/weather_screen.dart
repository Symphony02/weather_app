// lib/weather_screen.dart
import 'package:flutter/material.dart';
import 'weather_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? weatherData;
  final TextEditingController _controller = TextEditingController();

  Future<void> _getWeather() async {
    final city = _controller.text;
    if (city.isNotEmpty) {
      try {
        final data = await _weatherService.fetchWeather(city);
        setState(() {
          weatherData = data;
        });
      } catch (e) {
        setState(() {
          weatherData = null;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _getWeather,
                ),
              ),
            ),
            SizedBox(height: 20),
            weatherData != null
                ? Column(
                    children: [
                      Text('City: ${weatherData!['name']}',
                          style: TextStyle(fontSize: 24)),
                      Text(
                        'Temperature: ${weatherData!['main']['temp']}°C',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        'Condition: ${weatherData!['weather'][0]['description']}',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  )
                : Text('No data available', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

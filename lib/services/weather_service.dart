import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';

class WeatherService extends ChangeNotifier {
  final String apiKey = '75f6581525cd8aa8347cf85bd22e1dd8'; // Use your API key
  final String apiUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String forecastUrl = "https://api.openweathermap.org/data/2.5/forecast";

  Weather? _weatherData;
  List<Forecast>? _forecastData;

  Weather? get weatherData => _weatherData;
  List<Forecast>? get forecastData => _forecastData;

  // Fetch weather data by city name
  Future<void> fetchWeather(String city) async {
    final url = Uri.parse('$apiUrl?q=$city&units=metric&appid=$apiKey');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        _weatherData = Weather.fromJson(json);
        notifyListeners(); // Notify listeners that data has been updated
      } else {
        final errorJson = jsonDecode(response.body);
        throw Exception('Failed to load weather data: ${errorJson['message']}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch weather data: $e');
    }
  }

  // Fetch weather data by coordinates (latitude and longitude)
  Future<void> fetchWeatherByCoordinates(double latitude, double longitude) async {
    final url = Uri.parse('$apiUrl?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        _weatherData = Weather.fromJson(json);
        notifyListeners(); // Notify listeners that data has been updated
      } else {
        final errorJson = jsonDecode(response.body);
        throw Exception('Failed to load weather data: ${errorJson['message']}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch weather data: $e');
    }
  }

  // Fetch 5-day forecast data by city name
  Future<void> fetchForecast(String city) async {
    final url = Uri.parse('$forecastUrl?q=$city&units=metric&appid=$apiKey');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        _forecastData = (json['list'] as List).map((data) => Forecast.fromJson(data)).toList();
        notifyListeners(); // Notify listeners that data has been updated
      } else {
        final errorJson = jsonDecode(response.body);
        throw Exception('Failed to load forecast data: ${errorJson['message']}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch forecast data: $e');
    }
  }
}

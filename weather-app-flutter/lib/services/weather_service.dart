import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather.dart';
import '../models/location_suggestion.dart';
import '../models/weather_forecast.dart';

class WeatherService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String _forecastUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  static const String _geocodingUrl =
      'https://api.openweathermap.org/geo/1.0/direct';

  String get _apiKey {
    final key = dotenv.env['OPENWEATHER_API_KEY'];
    if (key == null || key.isEmpty || key == 'YOUR_API_KEY_HERE') {
      throw Exception(
        'OpenWeatherMap API key not found!\n'
        'Please:\n'
        '1. Get a free API key from https://openweathermap.org/api\n'
        '2. Replace YOUR_API_KEY_HERE in the .env file with your actual API key\n'
        '3. Restart the app',
      );
    }
    return key;
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Location services are disabled. Please enable location services and try again.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permissions are denied. Please grant location permission to get weather data.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable location permission in device settings.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 30),
        ),
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  Future<Weather> getWeatherForCurrentLocation() async {
    try {
      final Position position = await _getCurrentPosition();
      return await getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  Future<Weather> getWeatherByCity(String cityName) async {
    if (cityName.trim().isEmpty) {
      throw Exception('City name cannot be empty');
    }

    final String url =
        '$_baseUrl?q=${Uri.encodeComponent(cityName.trim())}&appid=${_apiKey}&units=metric';

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please check your OpenWeatherMap API key.',
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          'City "$cityName" not found. Please check the spelling and try again.',
        );
      } else {
        throw Exception(
          'Failed to load weather data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Request timeout. Please check your internet connection.',
        );
      } else if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        throw Exception('Failed to fetch weather data: $e');
      }
    }
  }

  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    final String url =
        '$_baseUrl?lat=$lat&lon=$lon&appid=${_apiKey}&units=metric';

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please check your OpenWeatherMap API key.',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Location not found.');
      } else {
        throw Exception(
          'Failed to load weather data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Request timeout. Please check your internet connection.',
        );
      } else if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        throw Exception('Failed to fetch weather data: $e');
      }
    }
  }

  Future<List<LocationSuggestion>> searchLocations(String query) async {
    if (query.trim().isEmpty || query.trim().length < 2) {
      return [];
    }

    final String url =
        '$_geocodingUrl?q=${Uri.encodeComponent(query.trim())}&limit=5&appid=${_apiKey}';

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => LocationSuggestion.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<ForecastData> getForecastForCurrentLocation() async {
    try {
      final Position position = await _getCurrentPosition();
      return await getForecastByCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  Future<ForecastData> getForecastByCoordinates(double lat, double lon) async {
    final String url =
        '$_forecastUrl?lat=$lat&lon=$lon&appid=${_apiKey}&units=metric';

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ForecastData.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please check your OpenWeatherMap API key.',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Location not found.');
      } else {
        throw Exception(
          'Failed to load forecast data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Request timeout. Please check your internet connection.',
        );
      } else if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        throw Exception('Failed to fetch forecast data: $e');
      }
    }
  }
}

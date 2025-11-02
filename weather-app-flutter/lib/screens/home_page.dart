import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';
import '../models/location_suggestion.dart';
import '../models/weather_forecast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();
  Future<Weather>? _weatherFuture;
  Future<ForecastData>? _forecastFuture;
  String _currentMode = 'location';

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _loadWeatherData() {
    setState(() {
      _weatherFuture = _weatherService.getWeatherForCurrentLocation();
      _forecastFuture = _weatherService.getForecastForCurrentLocation();
      _currentMode = 'location';
    });
  }

  void _searchWeatherByCity() {
    if (_cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a city name')));
      return;
    }

    setState(() {
      _weatherFuture = _weatherService.getWeatherByCity(
        _cityController.text.trim(),
      );
      _forecastFuture = _weatherFuture!.then(
        (weather) => _weatherService.getForecastByCoordinates(
          weather.latitude,
          weather.longitude,
        ),
      );
      _currentMode = 'search';
    });
  }

  void _searchWeatherBySuggestion(LocationSuggestion suggestion) {
    setState(() {
      _weatherFuture = _weatherService.getWeatherByCoordinates(
        suggestion.latitude,
        suggestion.longitude,
      );
      _forecastFuture = _weatherService.getForecastByCoordinates(
        suggestion.latitude,
        suggestion.longitude,
      );
      _currentMode = 'search';
    });
  }

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode.substring(0, 2)) {
      case '01':
        return Icons.wb_sunny;
      case '02':
      case '03':
      case '04':
        return Icons.wb_cloudy;
      case '09':
      case '10':
        return Icons.grain;
      case '11':
        return Icons.flash_on;
      case '13':
        return Icons.ac_unit;
      case '50':
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeatherData,
            tooltip: 'Reload Current Location',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TypeAheadField<LocationSuggestion>(
                      controller: _cityController,
                      suggestionsCallback: (pattern) async {
                        if (pattern.length < 2) return [];
                        return await _weatherService.searchLocations(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                          ),
                          title: Text(
                            suggestion.shortName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(suggestion.displayName),
                        );
                      },
                      onSelected: (suggestion) {
                        _cityController.text = suggestion.displayName;
                        _searchWeatherBySuggestion(suggestion);
                      },
                      builder: (context, controller, focusNode) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search city (e.g., Hanoi, Tokyo)',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _searchWeatherByCity(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _searchWeatherByCity,
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    tooltip: 'Search Weather',
                  ),
                  IconButton(
                    onPressed: _loadWeatherData,
                    icon: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 28,
                    ),
                    tooltip: 'Current Location',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: FutureBuilder<Weather>(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'Loading weather data...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadWeatherData,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final weather = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _currentMode == 'location'
                                      ? Icons.my_location
                                      : Icons.search,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _currentMode == 'location'
                                      ? 'Current Location'
                                      : 'Search Result',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              weather.cityName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              weather.temperatureString,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 72,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              weather.capitalizedDescription,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Location:',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        '${weather.latitude.toStringAsFixed(2)}, ${weather.longitude.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Updated:',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        '${weather.updatedAt.hour.toString().padLeft(2, '0')}:${weather.updatedAt.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text(
                        'No weather data available',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      );
                    }
                  },
                ),
              ),
            ),
            if (_forecastFuture != null)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '5-Day Forecast',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: FutureBuilder<ForecastData>(
                        future: _forecastFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Forecast unavailable',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            final forecasts = snapshot.data!.dailyForecasts
                                .take(5)
                                .toList();
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: forecasts.length,
                              itemBuilder: (context, index) {
                                final forecast = forecasts[index];
                                final isToday = index == 0;

                                return Container(
                                  width: 90,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: isToday
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        isToday ? 'Today' : forecast.dayName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      Icon(
                                        _getWeatherIcon(forecast.icon),
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      Text(
                                        forecast.temperatureString,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        forecast.minMaxString,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

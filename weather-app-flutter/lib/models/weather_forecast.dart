class WeatherForecast {
  final DateTime dateTime;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  WeatherForecast({
    required this.dateTime,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      minTemperature: (json['main']['temp_min'] as num).toDouble(),
      maxTemperature: (json['main']['temp_max'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? 'No description',
      icon: json['weather'][0]['icon'] ?? '01d',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get temperatureString => '${temperature.round()}°C';
  String get minMaxString =>
      '${minTemperature.round()}°/${maxTemperature.round()}°C';

  String get dayName {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[dateTime.weekday - 1];
  }

  String get timeString => '${dateTime.hour.toString().padLeft(2, '0')}:00';

  String get capitalizedDescription => description
      .split(' ')
      .map(
        (word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word,
      )
      .join(' ');
}

class ForecastData {
  final String cityName;
  final List<WeatherForecast> forecasts;

  ForecastData({required this.cityName, required this.forecasts});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      cityName: json['city']['name'] ?? 'Unknown Location',
      forecasts: (json['list'] as List)
          .map((item) => WeatherForecast.fromJson(item))
          .toList(),
    );
  }

  List<WeatherForecast> get dailyForecasts {
    final Map<String, WeatherForecast> dailyMap = {};

    for (final forecast in forecasts) {
      final dateKey =
          '${forecast.dateTime.year}-${forecast.dateTime.month}-${forecast.dateTime.day}';

      if (!dailyMap.containsKey(dateKey) ||
          (forecast.dateTime.hour - 12).abs() <
              (dailyMap[dateKey]!.dateTime.hour - 12).abs()) {
        dailyMap[dateKey] = forecast;
      }
    }

    return dailyMap.values.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }
}

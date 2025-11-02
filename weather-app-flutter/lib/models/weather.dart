class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double latitude;
  final double longitude;
  final DateTime updatedAt;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? 'Unknown Location',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? 'No description',
      icon: json['weather'][0]['icon'] ?? '01d',
      latitude: (json['coord']['lat'] as num).toDouble(),
      longitude: (json['coord']['lon'] as num).toDouble(),
      updatedAt: DateTime.now(),
    );
  }

  String get temperatureString => '${temperature.round()}°C';

  String get capitalizedDescription => description
      .split(' ')
      .map(
        (word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word,
      )
      .join(' ');
}

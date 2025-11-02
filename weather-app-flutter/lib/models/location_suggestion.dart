class LocationSuggestion {
  final String name;
  final String country;
  final String state;
  final double latitude;
  final double longitude;

  LocationSuggestion({
    required this.name,
    required this.country,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
    );
  }

  String get displayName {
    if (state.isNotEmpty && state != name) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }

  String get shortName => name;
}

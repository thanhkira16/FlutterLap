import 'package:equatable/equatable.dart';

/// Social link entity representing a social media profile
/// Immutable and follows Value Object pattern
class SocialLink extends Equatable {
  final String platform;
  final String url;
  final String iconName; // For icon mapping

  const SocialLink({
    required this.platform,
    required this.url,
    required this.iconName,
  });

  @override
  List<Object?> get props => [platform, url, iconName];

  @override
  String toString() =>
      'SocialLink(platform: $platform, url: $url, iconName: $iconName)';
}

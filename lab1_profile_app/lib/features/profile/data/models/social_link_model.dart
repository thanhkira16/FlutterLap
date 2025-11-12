import '../../domain/entities/social_link.dart';

/// Social Link Model for data layer
/// Extends entity and adds JSON serialization capability
/// Follows Open/Closed Principle - extends without modifying entity
class SocialLinkModel extends SocialLink {
  const SocialLinkModel({
    required super.platform,
    required super.url,
    required super.iconName,
  });

  /// Factory constructor from JSON
  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      platform: json['platform'] as String,
      url: json['url'] as String,
      iconName: json['iconName'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'platform': platform, 'url': url, 'iconName': iconName};
  }

  /// Convert model to entity
  SocialLink toEntity() {
    return SocialLink(platform: platform, url: url, iconName: iconName);
  }

  /// Create model from entity
  factory SocialLinkModel.fromEntity(SocialLink socialLink) {
    return SocialLinkModel(
      platform: socialLink.platform,
      url: socialLink.url,
      iconName: socialLink.iconName,
    );
  }
}

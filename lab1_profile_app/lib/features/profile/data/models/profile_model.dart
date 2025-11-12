import '../../domain/entities/profile.dart';
import 'skill_model.dart';
import 'social_link_model.dart';

/// Profile Model for data layer
/// Extends entity and adds JSON serialization capability
/// Follows Open/Closed Principle - extends without modifying entity
class ProfileModel extends Profile {
  const ProfileModel({
    required super.name,
    required super.title,
    required super.bio,
    required super.email,
    required super.phone,
    required super.profileImageUrl,
    required super.skills,
    required super.socialLinks,
  });

  /// Factory constructor from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String,
      title: json['title'] as String,
      bio: json['bio'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((skill) => SkillModel.fromJson(skill as Map<String, dynamic>))
          .toList(),
      socialLinks: (json['socialLinks'] as List<dynamic>)
          .map((link) => SocialLinkModel.fromJson(link as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'bio': bio,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'skills': skills
          .map((skill) => SkillModel.fromEntity(skill).toJson())
          .toList(),
      'socialLinks': socialLinks
          .map((link) => SocialLinkModel.fromEntity(link).toJson())
          .toList(),
    };
  }

  /// Convert model to entity
  Profile toEntity() {
    return Profile(
      name: name,
      title: title,
      bio: bio,
      email: email,
      phone: phone,
      profileImageUrl: profileImageUrl,
      skills: skills,
      socialLinks: socialLinks,
    );
  }

  /// Create model from entity
  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      name: profile.name,
      title: profile.title,
      bio: profile.bio,
      email: profile.email,
      phone: profile.phone,
      profileImageUrl: profile.profileImageUrl,
      skills: profile.skills,
      socialLinks: profile.socialLinks,
    );
  }
}

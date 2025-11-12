import 'package:equatable/equatable.dart';
import 'skill.dart';
import 'social_link.dart';

/// Profile entity representing user profile data
/// Immutable and follows Entity pattern from Clean Architecture
class Profile extends Equatable {
  final String name;
  final String title;
  final String bio;
  final String email;
  final String phone;
  final String profileImageUrl;
  final List<Skill> skills;
  final List<SocialLink> socialLinks;

  const Profile({
    required this.name,
    required this.title,
    required this.bio,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.skills,
    required this.socialLinks,
  });

  @override
  List<Object?> get props => [
    name,
    title,
    bio,
    email,
    phone,
    profileImageUrl,
    skills,
    socialLinks,
  ];

  @override
  String toString() =>
      'Profile(name: $name, title: $title, email: $email, phone: $phone)';
}

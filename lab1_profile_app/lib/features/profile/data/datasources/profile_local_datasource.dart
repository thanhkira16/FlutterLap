import '../models/profile_model.dart';
import '../models/skill_model.dart';
import '../models/social_link_model.dart';

/// Local data source for profile data
/// Follows Single Responsibility Principle - handles only local data retrieval
/// In a real app, this could fetch from local database or shared preferences
abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
}

/// Implementation of ProfileLocalDataSource
/// Provides mock data for demonstration
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<ProfileModel> getProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - in real app, this would come from local storage
    return const ProfileModel(
      name: 'Trương Ngọc Khánh Linh',
      title: 'Senior Flutter Developer',
      bio:
          'Passionate mobile developer with 10+ years of experience in building beautiful and performant cross-platform applications. Specialized in Flutter, Android, and Clean Architecture.',
      email: 'klinhtruong04@example.com',
      phone: '+84 123 456 789',
      profileImageUrl:
          'https://ui-avatars.com/api/?name=Truong+Ngoc+Khanh+Linh&size=200&background=4285F4&color=fff',
      skills: [
        SkillModel(name: 'Flutter', level: 'Expert', proficiency: 0.95),
        SkillModel(name: 'Dart', level: 'Expert', proficiency: 0.95),
        SkillModel(
          name: 'Android (Kotlin/Java)',
          level: 'Expert',
          proficiency: 0.90,
        ),
        SkillModel(
          name: 'Clean Architecture',
          level: 'Advanced',
          proficiency: 0.85,
        ),
        SkillModel(
          name: 'State Management (Provider/Bloc)',
          level: 'Advanced',
          proficiency: 0.88,
        ),
        SkillModel(name: 'Firebase', level: 'Advanced', proficiency: 0.80),
        SkillModel(name: 'REST API', level: 'Expert', proficiency: 0.92),
        SkillModel(name: 'Git', level: 'Advanced', proficiency: 0.87),
      ],
      socialLinks: [
        SocialLinkModel(
          platform: 'GitHub',
          url: 'https://github.com/yourusername',
          iconName: 'github',
        ),
        SocialLinkModel(
          platform: 'LinkedIn',
          url: 'https://linkedin.com/in/yourusername',
          iconName: 'linkedin',
        ),
        SocialLinkModel(
          platform: 'Twitter',
          url: 'https://twitter.com/yourusername',
          iconName: 'twitter',
        ),
        SocialLinkModel(
          platform: 'Email',
          url: 'mailto:nguyen.van.a@example.com',
          iconName: 'email',
        ),
        SocialLinkModel(
          platform: 'Website',
          url: 'https://yourwebsite.com',
          iconName: 'web',
        ),
      ],
    );
  }
}

import '../entities/profile.dart';

/// Profile Repository Interface
/// Follows Interface Segregation Principle and Dependency Inversion Principle
/// Domain layer defines the contract, Data layer implements it
abstract class ProfileRepository {
  /// Get user profile data
  Future<Profile> getProfile();

  /// Update profile data (for future extensibility)
  Future<void> updateProfile(Profile profile);
}

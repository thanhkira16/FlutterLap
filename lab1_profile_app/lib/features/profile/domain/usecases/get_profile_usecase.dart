import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

/// Use Case for getting profile data
/// Follows Single Responsibility Principle - handles only profile retrieval logic
/// Follows Dependency Inversion Principle - depends on abstraction (ProfileRepository)
class GetProfileUseCase {
  final ProfileRepository repository;

  const GetProfileUseCase(this.repository);

  /// Execute the use case to get profile
  Future<Profile> execute() async {
    return await repository.getProfile();
  }
}

import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/profile_model.dart';

/// Implementation of ProfileRepository
/// Follows Dependency Inversion Principle - implements interface from domain
/// Follows Single Responsibility Principle - handles only data coordination
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  const ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<Profile> getProfile() async {
    try {
      final profileModel = await localDataSource.getProfile();
      return profileModel.toEntity();
    } catch (e) {
      // In real app, handle errors properly with Either or Result types
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    try {
      // Convert entity to model for storage
      final profileModel = ProfileModel.fromEntity(profile);
      // In real app, save to local storage here
      // For now, just simulate save operation
      await Future.delayed(const Duration(milliseconds: 300));
      // ignore: unused_local_variable
      final _ = profileModel; // Will be used when implementing persistence
    } catch (e) {
      rethrow;
    }
  }
}

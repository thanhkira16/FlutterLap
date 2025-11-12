import 'package:flutter/material.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_profile_usecase.dart';

/// Profile Provider for managing profile state
/// Follows Single Responsibility Principle - manages only profile state
class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;

  ProfileProvider(this.getProfileUseCase);

  Profile? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Load profile data
  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await getProfileUseCase.execute();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load profile: ${e.toString()}';
      _profile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await loadProfile();
  }
}

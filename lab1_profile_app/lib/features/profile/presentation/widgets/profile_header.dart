import 'package:flutter/material.dart';
import '../../domain/entities/profile.dart';
import '../../../../core/constants/app_constants.dart';

/// Profile header widget showing avatar, name, title, and bio
/// Follows Single Responsibility Principle - displays only header information
class ProfileHeader extends StatelessWidget {
  final Profile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive avatar size
    final avatarRadius = screenWidth < 600
        ? AppConstants.avatarRadiusMedium
        : AppConstants.avatarRadiusLarge;

    return Card(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: avatarRadius,
              backgroundImage: NetworkImage(profile.profileImageUrl),
              backgroundColor: theme.colorScheme.primaryContainer,
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Name
            Text(
              profile.name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingSmall),

            // Title
            Text(
              profile.title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Bio
            Text(
              profile.bio,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Contact Info
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppConstants.paddingMedium,
              runSpacing: AppConstants.paddingSmall,
              children: [
                _buildContactChip(context, Icons.email, profile.email),
                _buildContactChip(context, Icons.phone, profile.phone),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactChip(BuildContext context, IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: AppConstants.iconSizeSmall),
      label: Text(label),
      labelStyle: Theme.of(context).textTheme.bodySmall,
    );
  }
}

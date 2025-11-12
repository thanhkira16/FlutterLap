import 'package:flutter/material.dart';
import '../../domain/entities/skill.dart';
import '../../../../core/constants/app_constants.dart';

/// Skills section widget displaying all skills with proficiency bars
/// Follows Single Responsibility Principle - displays only skills information
class SkillsSection extends StatelessWidget {
  final List<Skill> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Icon(
                  Icons.code,
                  color: theme.colorScheme.primary,
                  size: AppConstants.iconSizeMedium,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Skills',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Skills List
            if (isSmallScreen)
              // Single column for small screens
              ...skills.map((skill) => _buildSkillItem(context, skill))
            else
              // Two columns for larger screens
              Wrap(
                spacing: AppConstants.paddingMedium,
                runSpacing: AppConstants.paddingMedium,
                children: skills
                    .map(
                      (skill) => SizedBox(
                        width: (screenWidth - 80) / 2,
                        child: _buildSkillItem(context, skill),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(BuildContext context, Skill skill) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                skill.level,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            child: LinearProgressIndicator(
              value: skill.proficiency,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

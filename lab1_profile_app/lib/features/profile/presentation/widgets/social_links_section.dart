import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/social_link.dart';
import '../../../../core/constants/app_constants.dart';

/// Social links section widget displaying all social media links
/// Follows Single Responsibility Principle - displays only social links
class SocialLinksSection extends StatelessWidget {
  final List<SocialLink> socialLinks;

  const SocialLinksSection({super.key, required this.socialLinks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  Icons.link,
                  color: theme.colorScheme.primary,
                  size: AppConstants.iconSizeMedium,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Connect With Me',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Social Links List
            ...socialLinks.map((link) => _buildSocialLinkItem(context, link)),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinkItem(BuildContext context, SocialLink link) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          _getIconData(link.iconName),
          color: theme.colorScheme.primary,
          size: AppConstants.iconSizeSmall,
        ),
      ),
      title: Text(
        link.platform,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        link.url,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.open_in_new,
        color: theme.colorScheme.onSurfaceVariant,
        size: AppConstants.iconSizeSmall,
      ),
      onTap: () => _launchUrl(link.url),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'github':
        return Icons.code;
      case 'linkedin':
        return Icons.business;
      case 'twitter':
        return Icons.tag;
      case 'email':
        return Icons.email;
      case 'web':
        return Icons.language;
      default:
        return Icons.link;
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

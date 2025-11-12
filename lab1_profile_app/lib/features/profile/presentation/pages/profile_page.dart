import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/skills_section.dart';
import '../widgets/social_links_section.dart';

/// Profile page - main screen of the app
/// Follows Single Responsibility Principle - handles only profile display
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Profile'),
        actions: const [ThemeToggleButton()],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          // Loading State
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error State
          if (profileProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profileProvider.errorMessage ?? 'An error occurred',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => profileProvider.loadProfile(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Success State
          final profile = profileProvider.profile;
          if (profile == null) {
            return const Center(child: Text('No profile data available'));
          }

          // Display Profile with Responsive Layout
          return RefreshIndicator(
            onRefresh: () => profileProvider.refreshProfile(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive: Use SingleChildScrollView for all screens
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth > 800
                          ? 800
                          : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile Header
                        ProfileHeader(profile: profile),

                        // Skills Section
                        SkillsSection(skills: profile.skills),

                        // Social Links Section
                        SocialLinksSection(socialLinks: profile.socialLinks),

                        // Bottom Spacing
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../providers/app_provider.dart';
import '../../../providers/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'widgets/profile_role_badge.dart';
import 'widgets/profile_stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    final String initials = user.fullName.isNotEmpty
        ? user.fullName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '??';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppConstants.paddingDefault),
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                initials,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              user.fullName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ProfileRoleBadge(role: user.role),
            const SizedBox(height: AppConstants.paddingLarge * 1.5),
            Row(
              children: [
                Expanded(
                  child: user.role.toLowerCase() == 'organizer'
                      ? ProfileStatCard(
                          title: 'Created',
                          value: appProvider.createdOpportunitiesCount(user.id).toString(),
                          icon: Icons.add_circle_outline,
                        )
                      : ProfileStatCard(
                          title: 'Joined Events',
                          value: appProvider.joinedEventIdsForUser(user.id).length.toString(),
                          icon: Icons.event_available,
                        ),
                ),
                const SizedBox(width: AppConstants.paddingDefault),
                Expanded(
                  child: ProfileStatCard(
                    title: 'Saved',
                    value: appProvider.bookmarkedEventIdsForUser(user.id).length.toString(),
                    icon: Icons.bookmark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge * 1.5),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email Address'),
                    subtitle: Text(user.email),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Account Type'),
                    subtitle: Text(user.role.toLowerCase() == 'student' ? 'Student Account' : 'Organizer Account'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge * 2),
            CustomButton(
              text: 'Log Out',
              onPressed: () async { await authProvider.logout(); },
              isPrimary: false,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
          ],
        ),
      ),
    );
  }
}

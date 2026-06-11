import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/fade_in_item.dart';
import '../../../providers/app_provider.dart';
import '../../../providers/auth_provider.dart';
import 'event_details_screen.dart';
import 'widgets/event_card.dart';

class SavedEventsScreen extends StatelessWidget {
  const SavedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final userId = context.watch<AuthProvider>().currentUser?.id ?? '';
    final savedIds = appProvider.bookmarkedEventIdsForUser(userId);
    final savedEvents = appProvider.opportunities
        .where((event) => savedIds.contains(event.id))
        .toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Saved Events', showBackButton: true),
      backgroundColor: AppColors.surface,
      body: savedEvents.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border_outlined,
                    size: 64,
                    color: AppColors.textLight,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No saved events yet',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bookmark an event to find it here later',
                    style: TextStyle(color: AppColors.textLight, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingDefault),
              itemCount: savedEvents.length,
              itemBuilder: (context, index) {
                return FadeInItem(
                  index: index,
                  child: EventCard(
                    event: savedEvents[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventDetailsScreen(event: savedEvents[index]),
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

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

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final userId = context.watch<AuthProvider>().currentUser?.id ?? '';
    final joinedIds = appProvider.joinedEventIdsForUser(userId);
    final joinedEvents = appProvider.opportunities
        .where((event) => joinedIds.contains(event.id))
        .toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Events', showBackButton: false),
      backgroundColor: AppColors.surface,
      body: joinedEvents.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    size: 64,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No joined events yet',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'RSVP to an opportunity to see it here',
                    style: TextStyle(color: AppColors.textLight, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingDefault),
              itemCount: joinedEvents.length,
              itemBuilder: (context, index) {
                return FadeInItem(
                  index: index,
                  child: EventCard(
                    event: joinedEvents[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(event: joinedEvents[index]),
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

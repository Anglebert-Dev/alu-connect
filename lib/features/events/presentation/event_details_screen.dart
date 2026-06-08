import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../providers/app_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../discussion/presentation/chat_screen.dart';
import '../../discussion/presentation/widgets/comments_section.dart';
import '../models/event_model.dart';
import 'widgets/event_info_section.dart';
import 'widgets/participants_section.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final user = context.watch<AuthProvider>().currentUser;
    final userId = user?.id ?? '';
    final userName = user?.fullName ?? '';
    final isOrganizer = userId == event.organizerId;
    final isJoined = appProvider.joinedEventIdsForUser(userId).contains(event.id);
    final isSaved = appProvider.bookmarkedEventIdsForUser(userId).contains(event.id);
    final participants = isOrganizer ? appProvider.getParticipantsForEvent(event.id) : <Map<String, String>>[];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Opportunity Details',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? AppColors.primary : AppColors.textSecondary,
            ),
            onPressed: () {
              context.read<AppProvider>().toggleBookmark(event.id, userId);
              AppToast.show(
                context,
                message: isSaved ? 'Removed from saved events' : 'Event saved successfully',
                type: ToastType.success,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventInfoSection(event: event),
            const SizedBox(height: AppConstants.paddingLarge * 2),
            if (isOrganizer)
              ParticipantsSection(participants: participants)
            else
              CustomButton(
                text: isJoined ? 'Leave Event' : 'RSVP Now',
                isPrimary: !isJoined,
                onPressed: () {
                  if (isJoined) {
                    context.read<AppProvider>().leaveEvent(event.id, userId);
                    AppToast.show(context, message: 'You have left this event', type: ToastType.success);
                  } else {
                    context.read<AppProvider>().joinEvent(event.id, userId, userName);
                    AppToast.show(context, message: 'Successfully joined event!', type: ToastType.success);
                  }
                },
              ),
            const SizedBox(height: AppConstants.paddingLarge),
            const Divider(),
            const SizedBox(height: AppConstants.paddingDefault),
            Text('Comments', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.paddingDefault),
            CommentsSection(eventId: event.id),
            const SizedBox(height: AppConstants.paddingLarge * 4),
          ],
        ),
      ),
      floatingActionButton: (isJoined || isOrganizer)
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen(event: event)),
                );
              },
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              label: const Text(
                'Live Chat',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}

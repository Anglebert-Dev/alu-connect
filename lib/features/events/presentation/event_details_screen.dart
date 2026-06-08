import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final userId = context.watch<AuthProvider>().currentUser?.id ?? '';
    final isJoined = appProvider.joinedEventIdsForUser(userId).contains(event.id);
    final isSaved = appProvider.bookmarkedEventIdsForUser(userId).contains(event.id);
    final categoryColor = AppColors.categoryColors[event.category] ?? AppColors.primary;
    final formattedDate = DateFormat('EEEE, MMMM d, y • h:mm a').format(event.date);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      event.category,
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),

                  _buildInfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: formattedDate,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    text: event.location,
                    color: AppColors.textPrimary,
                  ),

                  const SizedBox(height: AppConstants.paddingLarge),
                  const Divider(),
                  const SizedBox(height: AppConstants.paddingLarge),

                  Text(
                    'About this opportunity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppConstants.paddingDefault),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingLarge * 2),
                  
                  CustomButton(
                    text: isJoined ? 'Leave Event' : 'RSVP Now',
                    isPrimary: !isJoined,
                    onPressed: () {
                      if (isJoined) {
                        context.read<AppProvider>().leaveEvent(event.id, userId);
                        AppToast.show(
                          context,
                          message: 'You have left this event',
                          type: ToastType.success,
                        );
                      } else {
                        context.read<AppProvider>().joinEvent(event.id, userId);
                        AppToast.show(
                          context,
                          message: 'Successfully joined event!',
                          type: ToastType.success,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),

                  const Divider(),
                  const SizedBox(height: AppConstants.paddingDefault),
                  Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppConstants.paddingDefault),
                  CommentsSection(eventId: event.id),
                  const SizedBox(height: AppConstants.paddingLarge * 4),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isJoined
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(event: event),
                  ),
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

  Widget _buildInfoRow({required IconData icon, required String text, required Color color}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

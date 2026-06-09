import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/event_model.dart';

class EventInfoSection extends StatelessWidget {
  final EventModel event;

  const EventInfoSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppColors.categoryColors[event.category] ?? AppColors.primary;
    final formattedDate = DateFormat('EEEE, MMMM d, y • h:mm a').format(event.date);

    return Column(
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
            style: TextStyle(color: categoryColor, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          event.title,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.paddingLarge),
        _buildInfoRow(icon: Icons.calendar_today_outlined, text: formattedDate),
        const SizedBox(height: 12),
        _buildInfoRow(icon: Icons.location_on_outlined, text: event.location),
        const SizedBox(height: 12),
        _buildInfoRow(icon: Icons.person_outline, text: 'Organised by ${event.organizerName.isNotEmpty ? event.organizerName : 'Unknown'}'),
        const SizedBox(height: AppConstants.paddingLarge),
        const Divider(),
        const SizedBox(height: AppConstants.paddingLarge),
        Text('About this opportunity', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppConstants.paddingDefault),
        Text(
          event.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

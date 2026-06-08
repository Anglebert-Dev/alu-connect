import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ParticipantsSection extends StatelessWidget {
  final List<Map<String, String>> participants;

  const ParticipantsSection({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'People Attending',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${participants.length}',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (participants.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('No one has signed up yet.', style: TextStyle(color: AppColors.textSecondary)),
          )
        else
          ...participants.map((p) => _buildParticipantTile(p)),
      ],
    );
  }

  Widget _buildParticipantTile(Map<String, String> participant) {
    final name = participant['name'] ?? 'Unknown';
    final initials = name.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          initials,
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
      dense: true,
    );
  }
}

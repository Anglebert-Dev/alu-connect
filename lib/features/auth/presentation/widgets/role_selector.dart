import 'package:flutter/material.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String?> onChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am a...',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: selectedRole,
          decoration: const InputDecoration(),
          items: const [
            DropdownMenuItem(value: 'Student', child: Text('Student')),
            DropdownMenuItem(value: 'Organizer', child: Text('Organizer')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

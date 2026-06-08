import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../providers/app_provider.dart';
import '../../../../providers/auth_provider.dart';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedCategory = AppConstants.categories.firstWhere((c) => c != 'All');
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${_monthName(picked.month)} ${picked.day}, ${picked.year}';
      });
    }
  }

  String _monthName(int month) => const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ][month - 1];

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthProvider>().currentUser!;
    setState(() => _isLoading = true);

    final success = await context.read<AppProvider>().createOpportunity(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      date: _selectedDate!,
      location: _locationController.text.trim(),
      organizerId: user.id,
      organizerName: user.fullName,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        AppToast.show(context, message: 'Opportunity created successfully!', type: ToastType.success);
        for (final c in [_titleController, _descriptionController, _locationController, _dateController]) { c.clear(); }
        setState(() { _selectedDate = null; _selectedCategory = AppConstants.categories.firstWhere((c) => c != 'All'); });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = AppConstants.categories.where((c) => c != 'All').toList();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Opportunity',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 28.0,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 8.0),
          const Text('Fill in the details to publish a new opportunity.'),
          const SizedBox(height: AppConstants.paddingLarge),
          CustomTextField(
            label: 'Title',
            controller: _titleController,
            hintText: 'e.g., Annual Hackathon 2026',
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
          ),
          const SizedBox(height: AppConstants.paddingDefault),
          CustomTextField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Describe the opportunity...',
            maxLines: 4,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
          ),
          const SizedBox(height: AppConstants.paddingDefault),
          Text('Category', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(),
            items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (value) { if (value != null) setState(() => _selectedCategory = value); },
          ),
          const SizedBox(height: AppConstants.paddingDefault),
          Text('Date', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDate,
            child: AbsorbPointer(
              child: TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(hintText: 'Select event date', suffixIcon: Icon(Icons.calendar_today_outlined)),
                validator: (_) => _selectedDate == null ? 'Please select a date' : null,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingDefault),
          CustomTextField(
            label: 'Location',
            controller: _locationController,
            hintText: 'e.g., Innovation Hub, Room 101',
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Location is required' : null,
          ),
          const SizedBox(height: AppConstants.paddingLarge * 2),
          CustomButton(text: 'Publish Opportunity', isLoading: _isLoading, onPressed: _handleSubmit),
          const SizedBox(height: AppConstants.paddingLarge),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_app_bar.dart';
import 'widgets/create_event_form.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Opportunity', showBackButton: false),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingLarge),
          child: CreateEventForm(),
        ),
      ),
    );
  }
}

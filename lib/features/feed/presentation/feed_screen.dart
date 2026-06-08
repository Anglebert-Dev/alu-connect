import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../providers/app_provider.dart';
import '../../events/presentation/event_details_screen.dart';
import '../../events/presentation/widgets/event_card.dart';
import 'widgets/feed_search_bar.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final events = appProvider.filteredEvents;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Opportunity Feed', showBackButton: false),
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          FeedSearchBar(controller: _searchController),
          Expanded(
            child: events.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_outlined, size: 64, color: AppColors.textLight),
                        SizedBox(height: 12),
                        Text(
                          'No opportunities found',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Try a different search or category',
                          style: TextStyle(color: AppColors.textLight, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingDefault),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return EventCard(
                        event: events[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsScreen(event: events[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

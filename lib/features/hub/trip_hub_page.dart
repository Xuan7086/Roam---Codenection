import 'package:flutter/material.dart';

import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/brand_mark.dart';
import '../itinerary/itinerary_page.dart';
import '../onboarding/create_join_trip_page.dart';
import '../trip/models/trip.dart';

class TripHubPage extends StatelessWidget {
  const TripHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = AppScope.of(context).currentTrip;
    if (trip == null) return const _NoTripView();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewPlanSheet(context),
        backgroundColor: AppColors.terracotta,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New plan',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const Key('hub-scroll'),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 112),
          children: [
            const _TopBar(),
            const SizedBox(height: 22),
            _MyTripsSection(
              trip: trip,
              onOpenItinerary: () => _open(context, const ItineraryPage()),
            ),
            const SizedBox(height: 24),
            const _RecommendedPlans(),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _showNewPlanSheet(BuildContext context) {
    final navigator = Navigator.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            4,
            20,
            24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New plan',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              const Text(
                'Start fresh or let the AI importer turn a link into itinerary stops.',
                style: TextStyle(color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 18),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Paste a reel, short, or map link',
                  prefixIcon: Icon(Icons.auto_awesome_outlined),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    navigator.push(
                      MaterialPageRoute(builder: (_) => const ItineraryPage()),
                    );
                  },
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Extract with AI importer'),
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) => const CreateJoinTripPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_calendar_outlined),
                  label: const Text('Plan manually'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(children: [const RoamWordmark(), const Spacer()]);
  }
}

class _MyTripsSection extends StatelessWidget {
  const _MyTripsSection({required this.trip, required this.onOpenItinerary});

  final Trip trip;
  final VoidCallback onOpenItinerary;

  @override
  Widget build(BuildContext context) {
    final days = trip.endDate.difference(trip.startDate).inDays.abs() + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Trips', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        _MyTripCard(
          title: trip.name,
          location: trip.destination,
          duration: '$days day${days == 1 ? '' : 's'}',
          stops: '4 stops',
          imageAsset: 'assets/images/penang_active_trip.png',
          onTap: onOpenItinerary,
        ),
      ],
    );
  }
}

class _MyTripCard extends StatelessWidget {
  const _MyTripCard({
    required this.title,
    required this.location,
    required this.duration,
    required this.stops,
    required this.imageAsset,
    required this.onTap,
  });

  final String title;
  final String location;
  final String duration;
  final String stops;
  final String imageAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.parchment,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: AppColors.line),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: 76,
                height: 82,
                child: Image.asset(imageAsset, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 5,
                    children: [
                      _TripMeta(
                        icon: Icons.calendar_today_outlined,
                        label: duration,
                      ),
                      _TripMeta(icon: Icons.location_on_outlined, label: stops),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      _OnlineMemberStack(),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          '4 online · all in sync',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.sage,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.more_vert_rounded, color: AppColors.muted),
          ],
        ),
      ),
    ),
  );
}

class _TripMeta extends StatelessWidget {
  const _TripMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.blush,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.muted),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _OnlineMemberStack extends StatelessWidget {
  const _OnlineMemberStack();

  static const _members = [
    ('M', AppColors.blushStrong),
    ('C', Color(0xFFF7E7D9)),
    ('K', Color(0xFFE7F1E4)),
    ('S', Color(0xFFF4E2EC)),
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 71,
    height: 28,
    child: Stack(
      children: [
        for (var index = 0; index < _members.length; index++)
          Positioned(
            left: index * 15.0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: _members[index].$2,
                  child: Text(
                    _members[index].$1,
                    style: const TextStyle(
                      color: AppColors.terracottaDark,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Positioned(
                  right: -1,
                  bottom: -1,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: AppColors.sage,
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

class _RecommendedPlans extends StatelessWidget {
  const _RecommendedPlans();

  static const _plans = [
    _PlanIdea(
      title: '2 Days 1 Night Malacca Trip',
      duration: '2D1N',
      stops: '8 spots',
      imageAsset: 'assets/images/melaka_recommended_trip.png',
    ),
    _PlanIdea(
      title: '3 Days 2 Nights Ipoh Trip',
      duration: '3D2N',
      stops: '10 spots',
      imageAsset: 'assets/images/ipoh_recommended_trip.png',
    ),
    _PlanIdea(
      title: '5 Days 4 Nights Sabah Trip',
      duration: '5D4N',
      stops: '12 spots',
      imageAsset: 'assets/images/sabah_recommended_trip.png',
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Recommended plans',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 5),
      const Text(
        'Local ideas to save, customise, or use as your next itinerary.',
        style: TextStyle(color: AppColors.muted, height: 1.4),
      ),
      const SizedBox(height: 13),
      SizedBox(
        height: 224,
        child: ListView.separated(
          key: const Key('recommended-plans-scroll'),
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          itemCount: _plans.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) =>
              _RecommendedPlanCard(plan: _plans[index]),
        ),
      ),
    ],
  );
}

class _RecommendedPlanCard extends StatelessWidget {
  const _RecommendedPlanCard({required this.plan});

  final _PlanIdea plan;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 180,
    child: Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${plan.title} saved as a plan idea.')),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(plan.imageAsset, fit: BoxFit.cover),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x05000000), Color(0xC0000000)],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _PlanPill(label: '${plan.duration} · ${plan.stops}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PlanPill extends StatelessWidget {
  const _PlanPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0x44FFFFFF),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
  );
}

class _PlanIdea {
  const _PlanIdea({
    required this.title,
    required this.duration,
    required this.stops,
    required this.imageAsset,
  });

  final String title;
  final String duration;
  final String stops;
  final String imageAsset;
}

class _NoTripView extends StatelessWidget {
  const _NoTripView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RoamWordmark(size: 28),
              const SizedBox(height: 24),
              Text(
                'Your next story starts here.',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Create a journey or join your group to open the trip hub.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateJoinTripPage()),
                ),
                child: const Text('Create or join a trip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

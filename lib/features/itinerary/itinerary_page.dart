import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/brand_mark.dart';
import '../documents/documents_page.dart';
import '../wallet/wallet_page.dart';

/// A route-first itinerary prototype. The map is deliberately static so this
/// screen works without a map SDK, network connection, or location permission.
class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key, this.showBackButton = true});

  /// The bottom-navigation instance is already part of the app shell, so it
  /// should not offer a redundant return action. Pushed itinerary pages do.
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final trip = AppScope.of(context).currentTrip;
    final tripName = trip?.name ?? 'Your journey';
    final destination = trip?.destination ?? 'Your destination';
    final travellers = trip?.memberCount ?? 4;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _RouteMap()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  if (showBackButton) ...[
                    _MapAction(
                      icon: Icons.arrow_back_rounded,
                      label: 'Return',
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 6),
                  ],
                  const RoamWordmark(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.parchment.withValues(alpha: .92),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A2C2623),
                            blurRadius: 12,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        '$destination route',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: .50,
            minChildSize: .27,
            maxChildSize: .92,
            snap: true,
            builder: (context, controller) => _ItinerarySheet(
              controller: controller,
              tripName: tripName,
              destination: destination,
              travellers: travellers,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapAction extends StatelessWidget {
  const _MapAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.parchment.withValues(alpha: .94),
        shape: const CircleBorder(),
        elevation: 3,
        shadowColor: const Color(0x332C2623),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}

class _ItinerarySheet extends StatelessWidget {
  const _ItinerarySheet({
    required this.controller,
    required this.tripName,
    required this.destination,
    required this.travellers,
  });

  final ScrollController controller;
  final String tripName;
  final String destination;
  final int travellers;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x332C2623),
            blurRadius: 22,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 11),
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.line,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.blushStrong,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.sunny, color: AppColors.amber),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tripName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Day 2 · $travellers travellers · Drag for itinerary',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showSheetMessage(
                    context,
                    'Share link copied in this prototype.',
                  ),
                  icon: const Icon(Icons.ios_share_outlined),
                ),
                IconButton(
                  onPressed: () => _showSheetMessage(
                    context,
                    'Trip settings are a prototype action.',
                  ),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              controller: controller,
              key: const Key('itinerary-sheet-scroll'),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
              children: [
                Text(
                  'Trip essentials',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Keep plans, spending, and stays with your daily route.',
                  style: TextStyle(color: AppColors.muted, height: 1.4),
                ),
                const SizedBox(height: 12),
                _ItineraryToolTile(
                  icon: Icons.checklist_rounded,
                  title: 'Travel checklist',
                  detail: 'Passports, packing, and trip-readiness tasks.',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DocumentsPage()),
                  ),
                ),
                const SizedBox(height: 9),
                _ItineraryToolTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Group wallet',
                  detail: 'Shared expenses, balances, and receipt scans.',
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const WalletPage())),
                ),
                const SizedBox(height: 9),
                _ItineraryToolTile(
                  icon: Icons.hotel_outlined,
                  title: 'Add hotel',
                  detail: 'Save your stay, check-in details, and booking note.',
                  onTap: () => _showHotelPicker(context, destination),
                ),
                const SizedBox(height: 22),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Today’s route',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    _StatusChip(label: '4 stops', color: AppColors.sage),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'A visual route around $destination. Drag this sheet to see the full plan.',
                  style: const TextStyle(color: AppColors.muted, height: 1.4),
                ),
                const SizedBox(height: 17),
                const _DayRouteExpander(
                  day: 1,
                  stops: 3,
                  events: [
                    _RouteEvent(
                      time: '08:30 AM',
                      title: 'Arrival coffee at Armenian Street',
                      detail: 'Meet the group, settle in, and start with local kopi.',
                      tag: 'Completed',
                      kind: _EventKind.complete,
                    ),
                    _RouteEvent(
                      time: '10:00 AM',
                      title: 'George Town heritage walk',
                      detail:
                          'Explore murals, clan jetties, and heritage lanes.',
                      tag: 'Completed',
                      kind: _EventKind.complete,
                    ),
                    _RouteEvent(
                      time: '06:30 PM',
                      title: 'Gurney Drive hawker dinner',
                      detail: 'A relaxed first-night dinner by the waterfront.',
                      tag: 'Completed',
                      kind: _EventKind.upcoming,
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const _DayRouteExpander(
                  day: 2,
                  stops: 4,
                  events: [
                    _RouteEvent(
                      time: '09:00 AM',
                      title: 'Traditional breakfast stop',
                      detail: 'Check in with the group and begin the walking route.',
                      tag: 'Completed',
                      kind: _EventKind.complete,
                    ),
                    _RouteEvent(
                      time: '10:30 AM',
                      title: 'Heritage street discovery',
                      detail: 'Mural walk, local galleries, and photo-worthy corners.',
                      tag: 'In progress',
                      kind: _EventKind.active,
                    ),
                    _RouteEvent(
                      time: '12:30 PM',
                      title: 'Lunch with the group',
                      detail:
                          'Reservation confirmed for the whole travel crew.',
                      tag: '4 seats',
                      kind: _EventKind.upcoming,
                    ),
                    _RouteEvent(
                      time: '02:00 PM',
                      title: 'Indoor heritage stop',
                      detail:
                          'A weather-friendly reroute is ready if rain starts.',
                      tag: 'Rain plan',
                      kind: _EventKind.reroute,
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _ItineraryToolTile(
                  icon: Icons.add_a_photo_outlined,
                  title: 'Add photo to shared album',
                  detail: 'Save this day’s moments with the Heritage street discovery plan.',
                  onTap: () => _showSharedAlbumPicker(context),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Roam AI is ready to optimise today’s route.',
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: const Text('Optimize with AI'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _showSheetMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> _showHotelPicker(
    BuildContext context,
    String destination,
  ) async {
    final hotel = await Navigator.of(context).push<_HotelListing>(
      MaterialPageRoute(
        builder: (_) => _HotelPickerPage(
          destination: destination,
          hotels: _hotelsFor(destination),
        ),
      ),
    );
    if (!context.mounted || hotel == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${hotel.name} added to itinerary.')),
    );
  }

  static List<_HotelListing> _hotelsFor(String destination) {
    final area = destination.toLowerCase();
    if (area.contains('melaka') || area.contains('malacca')) {
      return const [
        _HotelListing(
          name: 'The Majestic Malacca',
          detail: 'Melaka River · 1.4 km from the heritage route',
          nightlyRate: 'RM 420 / night',
          imageAsset: 'assets/images/hotel_eastern_oriental_pool.png',
        ),
        _HotelListing(
          name: 'Liu Men Melaka',
          detail: 'Jonker Street · Heritage boutique stay',
          nightlyRate: 'RM 310 / night',
          imageAsset: 'assets/images/hotel_campbell_house.png',
        ),
        _HotelListing(
          name: 'Casa del Rio Melaka',
          detail: 'Riverside · Near Stadthuys and cafés',
          nightlyRate: 'RM 560 / night',
          imageAsset: 'assets/images/hotel_hard_rock_penang.png',
        ),
      ];
    }
    return const [
      _HotelListing(
        name: 'Hard Rock Hotel Penang',
        detail: 'Batu Ferringhi · Beachfront stay with pool access',
        nightlyRate: 'RM 520 / night',
        imageAsset: 'assets/images/hotel_hard_rock_penang.png',
      ),
      _HotelListing(
        name: 'The Prestige Hotel Penang',
        detail: 'Weld Quay · 8 min from the waterfront',
        nightlyRate: 'RM 380 / night',
        imageAsset: 'assets/images/hotel_eastern_oriental_pool.png',
      ),
      _HotelListing(
        name: 'Campbell House Penang',
        detail: 'Campbell Street · In the old town',
        nightlyRate: 'RM 330 / night',
        imageAsset: 'assets/images/hotel_campbell_house.png',
      ),
    ];
  }

  static void _showSharedAlbumPicker(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add photo to shared album',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Day 2 · Heritage street discovery',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Photo picker will add to this shared album.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Choose from device'),
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Camera capture will add to this shared album.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Take a photo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HotelListing {
  const _HotelListing({
    required this.name,
    required this.detail,
    required this.nightlyRate,
    required this.imageAsset,
  });

  final String name;
  final String detail;
  final String nightlyRate;
  final String imageAsset;
}

class _HotelPickerPage extends StatelessWidget {
  const _HotelPickerPage({required this.destination, required this.hotels});

  final String destination;
  final List<_HotelListing> hotels;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: 'Return to itinerary',
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: const Text('Add hotel'),
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        children: [
          Text(
            'Hotels in $destination',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 7),
          const Text(
            'Choose a stay to add its booking details to your itinerary.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            children: [
              _HotelFilter(label: 'Best match', selected: true),
              _HotelFilter(label: 'Near route'),
              _HotelFilter(label: 'Price'),
            ],
          ),
          const SizedBox(height: 18),
          ...hotels.map(
            (hotel) => Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: _HotelListingTile(
                hotel: hotel,
                onTap: () => Navigator.of(context).pop(hotel),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _HotelFilter extends StatelessWidget {
  const _HotelFilter({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(
      color: selected ? AppColors.blushStrong : AppColors.parchment,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: selected ? AppColors.terracottaDark : AppColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _HotelListingTile extends StatelessWidget {
  const _HotelListingTile({required this.hotel, required this.onTap});

  final _HotelListing hotel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.parchment,
    clipBehavior: Clip.antiAlias,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                hotel.imageAsset,
                width: 104,
                height: 104,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hotel.detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.nightlyRate,
                    style: const TextStyle(
                      color: AppColors.terracottaDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.terracottaDark,
            ),
          ],
        ),
      ),
    ),
  );
}

class _ItineraryToolTile extends StatelessWidget {
  const _ItineraryToolTile({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.blush,
    clipBehavior: Clip.antiAlias,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.parchment,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.terracottaDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    ),
  );
}

class _DayRouteExpander extends StatelessWidget {
  const _DayRouteExpander({
    required this.day,
    required this.stops,
    required this.events,
  });

  final int day;
  final int stops;
  final List<Widget> events;

  @override
  Widget build(BuildContext context) {
    final outline = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.line),
    );

    return Material(
      color: AppColors.parchment,
      clipBehavior: Clip.antiAlias,
      shape: outline,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: Key('day-$day-route'),
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          shape: outline,
          collapsedShape: outline,
          leading: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.blushStrong,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: AppColors.terracottaDark,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          title: Text(
            'Day $day route',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            '$stops stops · Tap to expand',
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          children: events,
        ),
      ),
    );
  }
}

enum _EventKind { complete, active, upcoming, reroute }

class _RouteEvent extends StatelessWidget {
  const _RouteEvent({
    required this.time,
    required this.title,
    required this.detail,
    required this.tag,
    required this.kind,
    this.isLast = false,
  });

  final String time;
  final String title;
  final String detail;
  final String tag;
  final _EventKind kind;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = switch (kind) {
      _EventKind.complete || _EventKind.upcoming => AppColors.sage,
      _EventKind.active => AppColors.terracotta,
      _EventKind.reroute => AppColors.amber,
    };
    final icon = switch (kind) {
      _EventKind.complete => Icons.check_rounded,
      _EventKind.active => Icons.directions_walk_rounded,
      _EventKind.upcoming => Icons.restaurant_rounded,
      _EventKind.reroute => Icons.alt_route_rounded,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: color,
                child: Icon(icon, size: 14, color: Colors.white),
              ),
              if (!isLast)
                Container(width: 2, height: 82, color: AppColors.line),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kind == _EventKind.reroute
                    ? const Color(0xFFFFF0D9)
                    : AppColors.blush,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: kind == _EventKind.active
                      ? AppColors.terracotta.withValues(alpha: .45)
                      : AppColors.line,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          time,
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      _StatusChip(label: tag, color: color),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _RouteMap extends StatelessWidget {
  const _RouteMap();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RouteMapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  final _water = const Color(0xFFA9DCE7);
  final _land = const Color(0xFFE9F0D8);
  final _park = const Color(0xFFC8DDC5);
  final _road = const Color(0xFFF9FCF8);
  final _minorRoad = const Color(0xD9E4E8E0);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _water);

    final coastline = Path()
      ..moveTo(size.width * .58, 0)
      ..cubicTo(
        size.width * .68,
        size.height * .10,
        size.width * .58,
        size.height * .22,
        size.width * .72,
        size.height * .34,
      )
      ..cubicTo(
        size.width * .91,
        size.height * .49,
        size.width * .72,
        size.height * .65,
        size.width,
        size.height * .78,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(coastline, Paint()..color = _land);

    final island = Path()
      ..moveTo(size.width * .08, size.height * .18)
      ..cubicTo(
        size.width * .25,
        size.height * .12,
        size.width * .44,
        size.height * .22,
        size.width * .45,
        size.height * .45,
      )
      ..cubicTo(
        size.width * .43,
        size.height * .64,
        size.width * .23,
        size.height * .77,
        size.width * .04,
        size.height * .70,
      )
      ..close();
    canvas.drawPath(island, Paint()..color = _park);

    final roadPaint = Paint()
      ..color = _road
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final minorPaint = Paint()
      ..color = _minorRoad
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final path in _roadPaths(size)) {
      canvas.drawPath(path, minorPaint);
    }
    final bridge = Path()
      ..moveTo(size.width * .35, size.height * .56)
      ..cubicTo(
        size.width * .52,
        size.height * .58,
        size.width * .66,
        size.height * .58,
        size.width * .9,
        size.height * .51,
      );
    canvas.drawPath(bridge, roadPaint);

    final route = Path()
      ..moveTo(size.width * .29, size.height * .70)
      ..cubicTo(
        size.width * .45,
        size.height * .61,
        size.width * .34,
        size.height * .49,
        size.width * .48,
        size.height * .42,
      )
      ..cubicTo(
        size.width * .60,
        size.height * .36,
        size.width * .42,
        size.height * .27,
        size.width * .55,
        size.height * .20,
      );
    canvas.drawPath(
      route,
      Paint()
        ..color = AppColors.terracotta
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    final points = [
      Offset(size.width * .29, size.height * .70),
      Offset(size.width * .43, size.height * .55),
      Offset(size.width * .48, size.height * .42),
      Offset(size.width * .55, size.height * .20),
    ];
    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      canvas.drawCircle(
        point,
        index == 1 ? 13 : 10,
        Paint()..color = AppColors.parchment,
      );
      canvas.drawCircle(
        point,
        index == 1 ? 9 : 7,
        Paint()..color = index == 1 ? AppColors.terracotta : AppColors.sage,
      );
      if (index == 1) {
        canvas.drawCircle(point, 3, Paint()..color = AppColors.parchment);
      }
    }

    _label(canvas, size, 'START', Offset(size.width * .12, size.height * .71));
    _label(
      canvas,
      size,
      'OLD TOWN',
      Offset(size.width * .30, size.height * .36),
    );
    _label(canvas, size, 'LUNCH', Offset(size.width * .50, size.height * .13));
    _label(
      canvas,
      size,
      'ROUTE MAP',
      Offset(size.width * .64, size.height * .64),
      subtle: true,
    );
  }

  List<Path> _roadPaths(Size size) => [
    Path()
      ..moveTo(size.width * .08, size.height * .30)
      ..cubicTo(
        size.width * .24,
        size.height * .36,
        size.width * .37,
        size.height * .28,
        size.width * .58,
        size.height * .30,
      ),
    Path()
      ..moveTo(size.width * .12, size.height * .50)
      ..cubicTo(
        size.width * .23,
        size.height * .42,
        size.width * .48,
        size.height * .52,
        size.width * .77,
        size.height * .44,
      ),
    Path()
      ..moveTo(size.width * .26, size.height * .80)
      ..cubicTo(
        size.width * .35,
        size.height * .65,
        size.width * .66,
        size.height * .74,
        size.width * .9,
        size.height * .82,
      ),
    Path()
      ..moveTo(size.width * .72, size.height * .05)
      ..cubicTo(
        size.width * .70,
        size.height * .30,
        size.width * .88,
        size.height * .39,
        size.width * .96,
        size.height * .60,
      ),
  ];

  void _label(
    Canvas canvas,
    Size size,
    String text,
    Offset offset, {
    bool subtle = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: subtle ? const Color(0x995C7678) : const Color(0xFF355A60),
          fontSize: subtle ? 10 : 11,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: size.width * .3);
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _RouteMapPainter oldDelegate) => false;
}

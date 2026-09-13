import 'package:flutter/material.dart';

import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/malaysia_footprint_map.dart';
import 'currency_checker_page.dart';
import 'emergency_contact_page.dart';
import '../itinerary/itinerary_page.dart';
import '../onboarding/create_join_trip_page.dart';
import '../onboarding/welcome_page.dart';

class LegacyProfilePage extends StatelessWidget {
  const LegacyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.user;
    final trip = state.currentTrip;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const Key('profile-scroll'),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Return',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 2),
                const CircleAvatar(
                  radius: 21,
                  backgroundColor: AppColors.parchment,
                  child: Icon(
                    Icons.explore_rounded,
                    color: AppColors.terracottaDark,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Roam · Travel Studio',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Malaysia footprint',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Badge(
                    label: Text('1'),
                    child: Icon(Icons.notifications_none_rounded),
                  ),
                ),
                const SizedBox(width: 3),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 248,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 205,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: const MalaysiaFootprintMap(),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.parchment.withValues(alpha: .92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '● MALAYSIA FOOTPRINT',
                        style: TextStyle(
                          color: AppColors.terracottaDark,
                          fontSize: 10,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sageLight.withValues(alpha: .94),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '4 places lit up',
                        style: TextStyle(
                          color: AppColors.sage,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor: AppColors.parchment,
                            child: CircleAvatar(
                              radius: 47,
                              backgroundColor: AppColors.blushStrong,
                              child: Text(
                                user?.initials ?? 'R',
                                style: const TextStyle(
                                  color: AppColors.terracottaDark,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            right: 0,
                            bottom: 2,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: AppColors.terracotta,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 7,
                children: [
                  Text(
                    user?.name ?? 'Traveller',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const _ProfileTag('Pro Wanderer'),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                '@${(user?.name ?? 'roam traveller').replaceAll(' ', '').toLowerCase()} · ${trip?.destination ?? 'Malaysia'}',
                style: const TextStyle(color: AppColors.muted),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                user?.bio.isNotEmpty == true ? user!.bio : 'Visual storyteller & coffee hunter. Collecting local Malaysian moments one place at a time ✨',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.ink, height: 1.4),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 17),
                    label: const Text('Edit profile'),
                  ),
                ),
                const SizedBox(width: 8),
                _SquareButton(icon: Icons.public_outlined, onTap: () {}),
                const SizedBox(width: 8),
                _SquareButton(icon: Icons.share_outlined, onTap: () {}),
                const SizedBox(width: 8),
                _SquareButton(icon: Icons.settings_outlined, onTap: () {}),
              ],
            ),
            const SizedBox(height: 17),
            const _StatsCard(),
            const SizedBox(height: 17),
            _ActiveTripCard(
              title: trip?.name ?? 'No active escape',
              destination: trip?.destination ?? 'Create or join a trip',
              memberCount: trip?.memberCount ?? 0,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateJoinTripPage()),
              ),
            ),
            const SizedBox(height: 17),
            const _SegmentedLabels(),
            const SizedBox(height: 13),
            const _BadgeRow(
              icon: Icons.account_balance_outlined,
              title: 'Heritage sleuth',
              detail: '12 cultural landmarks logged',
              tag: 'Level 4',
              color: AppColors.terracotta,
            ),
            const SizedBox(height: 9),
            const _BadgeRow(
              icon: Icons.ramen_dining_outlined,
              title: 'Street food connoisseur',
              detail: 'Local eateries and coffee saved',
              tag: 'Verified',
              color: AppColors.amber,
            ),
            const SizedBox(height: 9),
            const _BadgeRow(
              icon: Icons.credit_score_outlined,
              title: 'Prompt settler',
              detail: 'Flawless squad ledger record',
              tag: '100%',
              color: AppColors.sage,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Travel Preferences & Vibe',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.tune, color: AppColors.terracottaDark),
              ],
            ),
            const SizedBox(height: 12),
            _PreferencesCard(userInterests: user?.interests ?? const []),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Travel essentials',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const Icon(
                  Icons.health_and_safety_outlined,
                  color: AppColors.terracottaDark,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _TravelToolsCard(
              onEmergency: () => _showEmergencyContact(context),
              onCurrency: () => _showCurrencyChecker(context),
              onHistory: () => _showPlanHistory(context),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                state.logOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.terracottaDark,
                alignment: Alignment.centerLeft,
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log out of Roam'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTag extends StatelessWidget {
  const _ProfileTag(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.blushStrong,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: AppColors.terracottaDark,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.blush,
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(icon, color: AppColors.sage),
      ),
    ),
  );
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 13),
    decoration: BoxDecoration(
      color: AppColors.parchment,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.line),
    ),
    child: const Row(
      children: [
        _Stat('14', 'Escapes', AppColors.terracotta),
        _Stat('38', 'Lit up 🌎', AppColors.sage),
        _Stat('128', 'Pins', AppColors.amber),
        _Stat('RM 4.2k', 'Settled', AppColors.sage),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label, this.color);
  final String value;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 19,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    ),
  );
}

class _ActiveTripCard extends StatelessWidget {
  const _ActiveTripCard({
    required this.title,
    required this.destination,
    required this.memberCount,
    required this.onTap,
  });

  final String title;
  final String destination;
  final int memberCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.parchment,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '● ACTIVE ESCAPE SYNC',
                style: TextStyle(
                  color: AppColors.terracottaDark,
                  fontSize: 11,
                  letterSpacing: .6,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(destination, style: const TextStyle(color: AppColors.muted)),
              const SizedBox(height: 15),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.blushStrong,
                    child: Text('M', style: TextStyle(fontSize: 11)),
                  ),
                  const SizedBox(width: 5),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.sageLight,
                    child: Text('C', style: TextStyle(fontSize: 11)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$memberCount co-planners',
                    style: const TextStyle(
                      color: AppColors.sage,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.terracottaDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentedLabels extends StatelessWidget {
  const _SegmentedLabels();
  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _Segment('Saved badges', selected: true),
        SizedBox(width: 8),
        _Segment('Wish-bucket (18)'),
        SizedBox(width: 8),
        _Segment('Past escapes'),
      ],
    ),
  );
}

class _Segment extends StatelessWidget {
  const _Segment(this.text, {this.selected = false});
  final String text;
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: selected ? AppColors.terracotta : AppColors.blushStrong,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: selected ? Colors.white : AppColors.muted,
        fontWeight: FontWeight.w800,
        fontSize: 12,
      ),
    ),
  );
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.tag,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String detail;
  final String tag;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: AppColors.parchment,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.line),
    ),
    child: Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(
                detail,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        _ProfileTag(tag),
      ],
    ),
  );
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({required this.userInterests});
  final List<String> userInterests;
  @override
  Widget build(BuildContext context) {
    final tags = userInterests.isEmpty
        ? const [
            'Halal-friendly',
            'Walking < 15 mins',
            'Specialty coffee',
            'Rain prompt: Active',
          ]
        : userInterests;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: tags.map((tag) => Chip(label: Text(tag))).toList(),
          ),
          const SizedBox(height: 13),
          const _PreferenceLine(
            icon: Icons.currency_exchange,
            title: 'Default ledger currency',
            detail: 'MYR (Ringgit) · Auto USD conversion',
            action: 'Change',
          ),
          const SizedBox(height: 8),
          const _PreferenceLine(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Linked split wallet',
            detail: 'Mock wallet ready for your group',
            action: 'Linked',
          ),
        ],
      ),
    );
  }
}

class _PreferenceLine extends StatelessWidget {
  const _PreferenceLine({
    required this.icon,
    required this.title,
    required this.detail,
    required this.action,
  });
  final IconData icon;
  final String title;
  final String detail;
  final String action;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: AppColors.blush,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.sage),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: AppColors.terracottaDark,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

class _TravelToolsCard extends StatelessWidget {
  const _TravelToolsCard({
    required this.onEmergency,
    required this.onCurrency,
    required this.onHistory,
  });

  final VoidCallback onEmergency;
  final VoidCallback onCurrency;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.parchment,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17),
      side: const BorderSide(color: AppColors.line),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(
        children: [
          _ProfileTool(
            icon: Icons.emergency_outlined,
            title: 'Emergency contact',
            detail: 'Aina Rahman · +60 12-668 4210',
            onTap: onEmergency,
          ),
          const Divider(),
          _ProfileTool(
            icon: Icons.currency_exchange_rounded,
            title: 'Currency checker',
            detail: '1 USD ≈ RM 4.66 · Quick MYR conversion',
            onTap: onCurrency,
          ),
          const Divider(),
          _ProfileTool(
            icon: Icons.history_rounded,
            title: 'Travel plan history',
            detail: '2 completed Malaysia trips',
            onTap: onHistory,
          ),
        ],
      ),
    ),
  );
}

class _ProfileTool extends StatelessWidget {
  const _ProfileTool({
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
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: AppColors.muted),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          detail,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    ),
    trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
    onTap: onTap,
  );
}

void _showEmergencyContact(BuildContext context) {
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
              'Emergency contact',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.blushStrong,
                child: Text('AR', style: TextStyle(fontSize: 11)),
              ),
              title: Text(
                'Aina Rahman',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('+60 12-668 4210 · Sister'),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Emergency calling is a prototype action.'),
                    ),
                  );
                },
                icon: const Icon(Icons.call_outlined),
                label: const Text('Call emergency contact'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showCurrencyChecker(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Currency checker',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'A quick local reference for the group wallet.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.blush,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RM 100.00',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '≈ USD 21.46 · 1 USD ≈ RM 4.66',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showPlanHistory(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Travel plan history',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 11),
            const _HistoryPlan(
              title: 'Melaka food weekend',
              detail: '12–14 Jul 2026 · 3 travellers · Completed',
            ),
            const Divider(),
            const _HistoryPlan(
              title: 'Langkawi island reset',
              detail: '22–25 Mar 2026 · 2 travellers · Completed',
            ),
          ],
        ),
      ),
    ),
  );
}

class _HistoryPlan extends StatelessWidget {
  const _HistoryPlan({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: const Icon(Icons.route_outlined, color: AppColors.sage),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text(detail),
  );
}

/// The current, deliberately focused profile experience used from the bottom
/// navigation. The previous profile composition remains above as a reference
/// for prototype-only components that may be revisited later.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  String _currency = 'MYR (Ringgit)';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final trip = state.currentTrip;
    final days = trip == null
        ? 6
        : trip.endDate.difference(trip.startDate).inDays.abs() + 1;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const Key('profile-scroll'),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 108),
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            const _ProfileMapHeader(),
            const SizedBox(height: 10),
            Center(
              child: Text(
                state.user?.name ?? 'Traveller',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => _showProfileEditor(context, state),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit profile'),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Your Trips',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 5),
            const Text(
              'Your current plan and previous Malaysian getaways.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 13),
            _ProfileTripCard(
              image: 'assets/images/penang_active_trip.png',
              status: 'CURRENT TRIP',
              title: trip?.name ?? 'Penang Heritage Escape',
              detail: trip?.destination ?? 'George Town, Penang',
              metadata: '$days days · ${trip?.memberCount ?? 4} travellers',
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ItineraryPage())),
            ),
            const SizedBox(height: 10),
            _ProfileTripCard(
              image: 'assets/images/melaka_recommended_trip.png',
              status: 'PAST TRIP',
              title: 'Melaka Riverside Weekend',
              detail: 'Melaka, Malaysia',
              metadata: '2 days · 1 night',
              onTap: () => _showTripMessage(context, 'Melaka trip details'),
            ),
            const SizedBox(height: 10),
            _ProfileTripCard(
              image: 'assets/images/ipoh_recommended_trip.png',
              status: 'PAST TRIP',
              title: 'Ipoh Old Town Escape',
              detail: 'Ipoh, Perak',
              metadata: '3 days · 2 nights',
              onTap: () => _showTripMessage(context, 'Ipoh trip details'),
            ),
            const SizedBox(height: 28),
            Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            _SettingsList(
              notificationsEnabled: _notificationsEnabled,
              currency: _currency,
              emergencyDetail:
                  '${state.emergencyContact.name} · ${state.emergencyContact.phone}',
              onNotificationChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
              onCurrency: _selectCurrency,
              onEmergency: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      EmergencyContactPage(contact: state.emergencyContact),
                ),
              ),
              onCurrencyChecker: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CurrencyCheckerPage()),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  state.logOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomePage()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.terracottaDark,
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log out of Roam'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectCurrency() async {
    final currency = await showModalBottomSheet<String>(
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
                'Default currency',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use this currency when creating a new trip wallet.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              for (final option in const [
                'MYR (Ringgit)',
                'USD (US Dollar)',
                'SGD (Singapore Dollar)',
              ])
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(option),
                  leading: Icon(
                    option == _currency
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: option == _currency
                        ? AppColors.terracotta
                        : AppColors.muted,
                  ),
                  onTap: () => Navigator.of(sheetContext).pop(option),
                ),
            ],
          ),
        ),
      ),
    );
    if (!mounted || currency == null) return;
    setState(() => _currency = currency);
  }
}

class _ProfileMapHeader extends StatelessWidget {
  const _ProfileMapHeader();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 212,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 170,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: const MalaysiaFootprintMap(),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.parchment.withValues(alpha: .92),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'MALAYSIA FOOTPRINT',
              style: TextStyle(
                color: AppColors.terracottaDark,
                fontSize: 10,
                letterSpacing: .5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 94,
              height: 94,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.parchment,
                shape: BoxShape.circle,
              ),
              child: const ClipOval(
                child: Image(
                  image: AssetImage('assets/images/profile_avatar.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ProfileTripCard extends StatelessWidget {
  const _ProfileTripCard({
    required this.image,
    required this.status,
    required this.title,
    required this.detail,
    required this.metadata,
    required this.onTap,
  });

  final String image;
  final String status;
  final String title;
  final String detail;
  final String metadata;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.parchment,
    clipBehavior: Clip.antiAlias,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                      color: AppColors.terracottaDark,
                      fontSize: 10,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    metadata,
                    style: const TextStyle(
                      color: AppColors.sage,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    ),
  );
}

class _SettingsList extends StatelessWidget {
  const _SettingsList({
    required this.notificationsEnabled,
    required this.currency,
    required this.emergencyDetail,
    required this.onNotificationChanged,
    required this.onCurrency,
    required this.onEmergency,
    required this.onCurrencyChecker,
  });

  final bool notificationsEnabled;
  final String currency;
  final String emergencyDetail;
  final ValueChanged<bool> onNotificationChanged;
  final VoidCallback onCurrency;
  final VoidCallback onEmergency;
  final VoidCallback onCurrencyChecker;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.parchment,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17),
      side: const BorderSide(color: AppColors.line),
    ),
    child: Column(
      children: [
        _SettingsRow(
          icon: Icons.notifications_outlined,
          title: 'Notification',
          trailing: Switch(
            value: notificationsEnabled,
            onChanged: onNotificationChanged,
          ),
        ),
        const Divider(indent: 58),
        _SettingsRow(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Default Currency',
          detail: currency,
          onTap: onCurrency,
        ),
        const Divider(indent: 58),
        _SettingsRow(
          icon: Icons.emergency_outlined,
          title: 'Emergency contact',
          detail: emergencyDetail,
          onTap: onEmergency,
        ),
        const Divider(indent: 58),
        _SettingsRow(
          icon: Icons.currency_exchange_rounded,
          title: 'Currency checker',
          detail: 'Quick MYR conversion',
          onTap: onCurrencyChecker,
        ),
      ],
    ),
  );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.detail,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? detail;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
    leading: Icon(icon, color: AppColors.terracottaDark),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: detail == null
        ? null
        : Text(
            detail!,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
    trailing:
        trailing ??
        const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
    onTap: onTap,
  );
}

void _showProfileEditor(BuildContext context, AppState state) {
  final nameController = TextEditingController(
    text: state.user?.name ?? 'Traveller',
  );
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
              'Edit profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty && state.user != null) {
                    state.updateProfile(state.user!.copyWith(name: name));
                  }
                  Navigator.of(sheetContext).pop();
                },
                child: const Text('Save profile'),
              ),
            ),
          ],
        ),
      ),
    ),
  ).whenComplete(nameController.dispose);
}

void _showTripMessage(BuildContext context, String trip) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$trip is saved in your trip history.')),
  );
}

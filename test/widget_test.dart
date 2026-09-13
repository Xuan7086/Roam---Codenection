import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:roam_travel_planner/app/roam_app.dart';
import 'package:roam_travel_planner/app/app_shell.dart';
import 'package:roam_travel_planner/core/storage/app_state.dart';
import 'package:roam_travel_planner/core/theme/app_theme.dart';
import 'package:roam_travel_planner/features/itinerary/itinerary_page.dart';
import 'package:roam_travel_planner/features/profile/currency_checker_page.dart';
import 'package:roam_travel_planner/features/profile/emergency_contact_page.dart';
import 'package:roam_travel_planner/features/profile/profile_page.dart';
import 'package:roam_travel_planner/features/studio/studio_page.dart';
import 'package:roam_travel_planner/features/trip/trip_details_page.dart';
import 'package:roam_travel_planner/features/wallet/wallet_page.dart';

void main() {
  testWidgets('Welcome screen shows Roam entry points', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RoamApp());

    expect(find.text('ROAM'), findsOneWidget);
    expect(find.text('Plan better. Travel together.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Already have an account? Log In'), findsNothing);
    expect(AppState().user?.name, 'Synthesize');

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Create or join a trip'), findsOneWidget);
  });

  testWidgets('trip creation reaches the redesigned hub', (
    WidgetTester tester,
  ) async {
    final state = AppState();
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const TripDetailsPage(),
        ),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Who can access this trip?'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Create trip'));
    await tester.pumpAndSettle();

    expect(find.text('My Trips'), findsOneWidget);
    expect(state.currentTrip, isNotNull);
  });

  testWidgets('primary tabs fit a compact Android viewport', (
    WidgetTester tester,
  ) async {
    final state = AppState()
      ..logIn(email: 'alex@example.com')
      ..joinTrip('PENANG26');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(theme: AppTheme.light(), home: const AppShell()),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('My Trips'), findsOneWidget);
    expect(find.text('Guide'), findsNothing);
    expect(
      tester
          .getCenter(find.widgetWithText(FloatingActionButton, 'New plan'))
          .dx,
      greaterThan(tester.view.physicalSize.width / 2),
    );
    await tester.tap(find.text('New plan'));
    await tester.pumpAndSettle();
    expect(find.text('Extract with AI importer'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    for (final tab in ['Itinerary', 'Studio', 'Profile', 'Hub']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      if (tab == 'Itinerary') {
        expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
        expect(find.byIcon(Icons.search_rounded), findsNothing);
        expect(find.byIcon(Icons.tune_rounded), findsNothing);
        expect(find.byIcon(Icons.near_me_outlined), findsNothing);
        expect(find.byIcon(Icons.add_rounded), findsNothing);
        expect(
          find.text('Ask Roam AI to add a stop or reroute this day.'),
          findsNothing,
        );
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('itinerary contains the shared trip tools', (
    WidgetTester tester,
  ) async {
    final state = AppState()
      ..logIn(email: 'alex@example.com')
      ..joinTrip('PENANG26');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ItineraryPage(),
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Travel checklist'), findsOneWidget);
    expect(find.text('Group wallet'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Add hotel'),
      180,
      scrollable: find.descendant(
        of: find.byKey(const Key('itinerary-sheet-scroll')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    expect(find.text('Add hotel'), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add hotel'));
    await tester.pumpAndSettle();
    expect(find.text('Hotels in George Town, Penang'), findsOneWidget);
    expect(find.text('Hard Rock Hotel Penang'), findsOneWidget);
    expect(find.text('RM 520 / night'), findsOneWidget);
    await tester.tap(find.byTooltip('Return to itinerary'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Optimize with AI'),
      180,
      scrollable: find.descendant(
        of: find.byKey(const Key('itinerary-sheet-scroll')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    expect(find.text('Optimize with AI'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Day 2 route expands within the itinerary', (
    WidgetTester tester,
  ) async {
    final state = AppState()
      ..logIn(email: 'alex@example.com')
      ..joinTrip('PENANG26');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ItineraryPage(),
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('day-1-route')),
      180,
      scrollable: find.descendant(
        of: find.byKey(const Key('itinerary-sheet-scroll')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    expect(find.byKey(const Key('day-1-route')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('day-2-route')),
      180,
      scrollable: find.descendant(
        of: find.byKey(const Key('itinerary-sheet-scroll')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('day-2-route')));
    await tester.pumpAndSettle();

    expect(find.text('Heritage street discovery'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Hub recommendations scroll to the Sabah plan', (
    WidgetTester tester,
  ) async {
    final state = AppState()
      ..logIn(email: 'alex@example.com')
      ..joinTrip('PENANG26');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(theme: AppTheme.light(), home: const AppShell()),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Recommended plans'),
      240,
      scrollable: find.descendant(
        of: find.byKey(const Key('hub-scroll')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('recommended-plans-scroll')),
      const Offset(-360, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('5 Days 4 Nights Sabah Trip'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wallet receipt fits a compact Android viewport', (
    WidgetTester tester,
  ) async {
    final state = AppState()
      ..logIn(email: 'alex@example.com')
      ..joinTrip('PENANG26');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(theme: AppTheme.light(), home: const WalletPage()),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byTooltip('Return to itinerary'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Confirm splits'),
      220,
      scrollable: find.descendant(
        of: find.byKey(const Key('wallet-scroll')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Scan Receipt with AI'),
      220,
      scrollable: find.descendant(
        of: find.byKey(const Key('wallet-scroll')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    await tester.tap(find.text('Scan Receipt with AI'));
    await tester.pumpAndSettle();
    expect(find.text('Upload a photo'), findsOneWidget);
  });

  testWidgets('studio combines itinerary albums into a photo template', (
    WidgetTester tester,
  ) async {
    final state = AppState()
      ..logIn(email: 'alex@example.com')
      ..joinTrip('PENANG26');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(theme: AppTheme.light(), home: const StudioPage()),
      ),
    );

    expect(find.text('Create photo template'), findsOneWidget);
    await tester.tap(find.text('Start creating'));
    await tester.pumpAndSettle();
    expect(find.text('Choose shared albums'), findsOneWidget);

    await tester.tap(find.byKey(const Key('album-breakfast')));
    await tester.tap(find.byKey(const Key('album-heritage')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select photos from 2 albums'));
    await tester.pumpAndSettle();
    expect(find.text('Pick photos'), findsOneWidget);

    await tester.tap(find.byKey(const Key('photo-breakfast-kopi')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Create template with 1 photo'),
      220,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('studio-scroll')),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Scrollable &&
                  widget.axisDirection == AxisDirection.down,
            ),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create template with 1 photo'));
    await tester.pumpAndSettle();
    expect(find.text('Template canvas'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile settings fit a compact Android viewport', (
    WidgetTester tester,
  ) async {
    final state = AppState()
      ..logIn(email: 'alex@example.com')
      ..joinTrip('PENANG26');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(theme: AppTheme.light(), home: const ProfilePage()),
      ),
    );

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Log out of Roam'),
      220,
      scrollable: find.descendant(
        of: find.byKey(const Key('profile-scroll')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile emergency contact is editable in its own page', (
    WidgetTester tester,
  ) async {
    final state = AppState()
      ..logIn(email: 'alex@example.com')
      ..joinTrip('PENANG26');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: EmergencyContactPage(contact: state.emergencyContact),
        ),
      ),
    );

    expect(find.text('Contact details'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Siti Aminah');
    await tester.enterText(fields.at(1), 'Friend');
    await tester.enterText(fields.at(2), '+60 19-555 1234');
    await tester.tap(find.text('Save emergency contact'));
    await tester.pumpAndSettle();

    expect(state.emergencyContact.name, 'Siti Aminah');
    expect(state.emergencyContact.phone, '+60 19-555 1234');
    expect(tester.takeException(), isNull);
  });

  testWidgets('currency checker opens as a conversion page', (
    WidgetTester tester,
  ) async {
    final state = AppState()
      ..logIn(email: 'alex@example.com')
      ..joinTrip('PENANG26');
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const CurrencyCheckerPage(),
        ),
      ),
    );

    expect(find.text('TRIP EXCHANGE'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '50');
    await tester.pump();
    expect(find.text('50 MYR'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

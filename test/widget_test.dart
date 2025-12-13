import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:timetracker/main.dart';

void main() {
  testWidgets('Time Tracker app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const TimeTrackerApp());

    expect(find.text('Time Tracker'), findsOneWidget);
    expect(find.text('Welcome to Time Tracker'), findsOneWidget);
  });
}

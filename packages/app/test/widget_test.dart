import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whatnow_app/main.dart';

void main() {
  group('WhatnowApp', () {
    testWidgets(
      'Given an empty task list, '
      'When the user taps the FloatingActionButton and then checks the task, '
      'Then the task is added to the open list and removed when completed',
      (WidgetTester tester) async {
        await tester.pumpWidget(const WhatnowApp());

        expect(find.text('Eisenhower Todo'), findsOneWidget);
        expect(find.text('New Quick Task'), findsNothing);

        // Tap FloatingActionButton to add a new task (with null description)
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();

        expect(find.text('New Quick Task'), findsOneWidget);

        // Toggle completion checkbox to close the task
        final firstCheckbox = find.byType(Checkbox).first;
        await tester.tap(firstCheckbox);
        await tester.pump();

        expect(find.text('New Quick Task'), findsNothing);
      },
    );
  });
}

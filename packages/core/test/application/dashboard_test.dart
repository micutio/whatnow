import 'package:test/test.dart';
import 'package:whatnow_core/whatnow_core.dart';

void main() {
  // Dashboard lifecycle tests

  final dashboard = Dashboard();

  group('RQ-DB-1: A new task must belong to a topic, or unnamed', () {
    test('An empty dashboard contains only the unnamed topic', () {
      dashboard.getAllTopics().length == 1;
    });

    test('The unnamed topic should be available through its ID.', () {});
  });
}

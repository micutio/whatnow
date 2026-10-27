import 'package:test/test.dart';
import 'package:whatnow_cli/whatnow_cli.dart';

void main() {
  group('whatnow CLI', () {
    test('buildParser creates parser with help and version flags', () {
      final parser = buildParser();
      expect(parser.options.containsKey('help'), isTrue);
      expect(parser.options.containsKey('version'), isTrue);
    });

    test('REQ-CLI-1: Given --help flag, When runCli executes, Then usage is printed and exit code is 0', () {
      final out = StringBuffer();
      final code = runCli(['--help'], out: out);
      expect(code, equals(0));
      expect(out.toString(), contains('Usage: whatnow [options]'));
    });

    test('REQ-CLI-2: Given --version flag, When runCli executes, Then version is printed and exit code is 0', () {
      final out = StringBuffer();
      final code = runCli(['--version'], out: out);
      expect(code, equals(0));
      expect(out.toString(), contains('whatnow version'));
    });

    test('Given no arguments, When runCli executes, Then default banner is printed and exit code is 0', () {
      final out = StringBuffer();
      final code = runCli([], out: out);
      expect(code, equals(0));
      expect(out.toString(), contains('=== whatnow CLI ==='));
    });

    test('REQ-CLI-3 & REQ-CLI-4: Given an unknown option, When runCli executes, Then error is written to err sink and exit code is 64', () {
      final err = StringBuffer();
      final code = runCli(['--unknown-option-xyz'], err: err);
      expect(code, equals(64));
      expect(err.toString(), contains('Could not find an option'));
    });
  });
}

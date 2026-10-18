import 'dart:io';

import 'package:args/args.dart';

const String cliVersion = '0.1.0';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print usage information.',
    )
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print application version.',
    );
}

int runCli(List<String> args, {StringSink? out, StringSink? err}) {
  final stdoutSink = out ?? stdout;
  final stderrSink = err ?? stderr;
  final parser = buildParser();

  try {
    final results = parser.parse(args);

    if (results.flag('help')) {
      stdoutSink
        ..writeln(
          'whatnow CLI - Task management driven by Eisenhower priorities',
        )
        ..writeln()
        ..writeln('Usage: whatnow [options]')
        ..writeln()
        ..writeln(parser.usage);
      return 0;
    }

    if (results.flag('version')) {
      stdoutSink.writeln('whatnow version $cliVersion');
      return 0;
    }

    stdoutSink
      ..writeln('=== whatnow CLI ===')
      ..writeln('under construction');

    return 0;
  } on FormatException catch (e) {
    stderrSink
      ..writeln(e.message)
      ..writeln()
      ..writeln(parser.usage);
    return 64;
  }
}

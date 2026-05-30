import 'dart:io';
import '../config/config_model.dart';
import '../config/config_parser.dart';

class HookRunner {
  /// Called by the generated .git/hooks/ script
  /// Reads config and executes all commands for the given hook
  static Future<void> run(String hookName) async {
    final hookType = HookType.fromString(hookName);

    if (hookType == null) {
      print('❌ Unknown hook "$hookName"');
      exit(1);
    }

    final config = ConfigParser.parse();
    final hookConfig = config.hooks[hookType];

    if (hookConfig == null) {
      print('⚠️  No config found for "$hookName" — skipping.');
      exit(0);
    }

    print('🪝 Running $hookName hooks...');

    if (hookConfig.parallel) {
      await _runParallel(hookConfig.commands);
    } else {
      await _runSequential(hookConfig.commands);
    }
  }

  static Future<void> _runSequential(Map<String, CommandConfig> commands) async {
    for (final entry in commands.entries) {
      await _runCommand(entry.key, entry.value);
    }
  }

  static Future<void> _runParallel(Map<String, CommandConfig> commands) async {
    await Future.wait(
      commands.entries.map((e) => _runCommand(e.key, e.value)),
    );
  }

  static Future<void> _runCommand(String name, CommandConfig config) async {
    print('  ▶ Running "$name"...');

    final parts = config.run.split(' ');
    final executable = parts.first;
    final arguments = parts.skip(1).toList();

    final result = await Process.run(
      executable,
      arguments,
      runInShell: true,
    );

    if (result.stdout.toString().isNotEmpty) {
      print(result.stdout);
    }

    if (result.exitCode != 0) {
      print('  ❌ "$name" failed:');
      print(result.stderr);
      exit(result.exitCode); // blocks the git action
    }

    print('  ✅ "$name" passed');
  }
}
import 'dart:io';
import '../config/config_model.dart';
import '../config/config_parser.dart';
import 'commit_msg_validator.dart';

class HookRunner {
  /// Called by the generated .git/hooks/ script
  static Future<void> run(String hookName, {String? arg}) async {
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

    if (hookType == HookType.commitMsg) {
      await _runCommitMsgHook(hookConfig, arg);
    } else {
      if (hookConfig.parallel) {
        await _runParallel(hookConfig.commands);
      } else {
        await _runSequential(hookConfig.commands);
      }
    }
  }

  static Future<void> _runCommitMsgHook(
    HookConfig config,
    String? msgFilePath,
  ) async {
    if (msgFilePath == null) {
      print('❌ No commit message file path provided.');
      exit(1);
    }

    final message = File(msgFilePath).readAsStringSync();

    for (final entry in config.msgCommands.entries) {
      final name = entry.key;
      final cmdConfig = entry.value;

      print('  ▶ Running "$name"...');

      if (cmdConfig.preset == 'conventional') {
        final result = CommitMsgValidator.validate(
          message,
          appendTypes: cmdConfig.appendTypes,
          overrideTypes: cmdConfig.overrideTypes,
        );

        if (!result.passed) {
          print('  ❌ "$name" failed:\n');
          print(result.message);
          exit(1);
        }

        print('  ✅ "$name" passed');
      } else {
        print('  ⚠️  Unknown preset "${cmdConfig.preset}" — skipping.');
      }
    }
  }

  static Future<void> _runSequential(
    Map<String, CommandConfig> commands,
  ) async {
    for (final entry in commands.entries) {
      await _runCommand(entry.key, entry.value);
    }
  }

  static Future<void> _runParallel(Map<String, CommandConfig> commands) async {
    await Future.wait(commands.entries.map((e) => _runCommand(e.key, e.value)));
  }

  static Future<void> _runCommand(String name, CommandConfig config) async {
    print('  ▶ Running "$name"...');

    final parts = config.run.split(' ');
    final executable = parts.first;
    final arguments = parts.skip(1).toList();

    final result = await Process.run(executable, arguments, runInShell: true);

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

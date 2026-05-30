import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;
import 'config_model.dart';

class ConfigParser {
  static const _configFileName = 'dart_githooks.yaml';

  /// Finds and parses dart_githooks.yaml from the project root
  static GitHooksConfig parse() {
    final configFile = _findConfigFile();
    final content = configFile.readAsStringSync();
    final yaml = loadYaml(content) as YamlMap;
    return _parseConfig(yaml);
  }

  static File _findConfigFile() {
    final configPath = path.join(Directory.current.path, _configFileName);
    final file = File(configPath);

    if (!file.existsSync()) {
      throw FileSystemException(
        'dart_githooks.yaml not found. Create one in your project root.',
        configPath,
      );
    }

    return file;
  }

  static GitHooksConfig _parseConfig(YamlMap yaml) {
    final hooks = <HookType, HookConfig>{};

    for (final entry in yaml.entries) {
      final hookType = HookType.fromString(entry.key as String);

      if (hookType == null) {
        print('⚠️  Unknown hook "${entry.key}" — skipping.');
        continue;
      }

      hooks[hookType] = _parseHookConfig(entry.value as YamlMap, hookType);
    }

    return GitHooksConfig(hooks: hooks);
  }

  static HookConfig _parseHookConfig(YamlMap yaml, HookType hookType) {
    final parallel = yaml['parallel'] as bool? ?? false;
    final commandsYaml = yaml['commands'] as YamlMap? ?? YamlMap();
    final commands = <String, CommandConfig>{};
    final msgCommands = <String, CommitMsgCommandConfig>{};

    for (final entry in commandsYaml.entries) {
      final name = entry.key as String;
      final value = entry.value as YamlMap;

      if (hookType == HookType.commitMsg) {
        msgCommands[name] = _parseCommitMsgCommandConfig(value);
      } else {
        commands[name] = _parseCommandConfig(value);
      }
    }

    return HookConfig(
      parallel: parallel,
      commands: commands,
      msgCommands: msgCommands,
    );
  }

  static CommitMsgCommandConfig _parseCommitMsgCommandConfig(YamlMap yaml) {
    final preset = yaml['preset'] as String?;

    if (preset == null) {
      throw FormatException('commit-msg command must have a "preset" field.');
    }

    return CommitMsgCommandConfig(preset: preset);
  }

  static CommandConfig _parseCommandConfig(YamlMap yaml) {
    final run = yaml['run'] as String?;

    if (run == null) {
      throw FormatException('Command is missing required "run" field.');
    }

    return CommandConfig(run: run, glob: yaml['glob'] as String?);
  }
}

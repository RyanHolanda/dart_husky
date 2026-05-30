/// Represents the entire dart_githooks.yaml config file
class GitHooksConfig {
  final Map<HookType, HookConfig> hooks;

  const GitHooksConfig({required this.hooks});
}

/// All supported git hook types
enum HookType {
  preCommit('pre-commit'),
  commitMsg('commit-msg'),
  prePush('pre-push'),
  postCheckout('post-checkout'),
  preMergeCommit('pre-merge-commit');

  final String scriptName; // matches the actual .git/hooks/ filename
  const HookType(this.scriptName);

  static HookType? fromString(String value) {
    for (final type in HookType.values) {
      if (type.scriptName == value) return type;
    }
    return null;
  }
}

/// Represents one hook block in the config (e.g. pre-commit:)
class HookConfig {
  final bool parallel;
  final Map<String, CommandConfig> commands;
  final Map<String, CommitMsgCommandConfig> msgCommands; // only used for commit-msg

  const HookConfig({
    this.parallel = false,
    this.commands = const {},
    this.msgCommands = const {},
  });
}

/// Represents one named command inside a hook
class CommandConfig {
  final String run;
  final String? glob; // optional: only run if matching files are staged

  const CommandConfig({
    required this.run,
    this.glob,
  });
}

/// Specific to commit-msg hook — uses preset instead of a shell command
class CommitMsgCommandConfig {
  final String preset; // e.g. 'conventional'

  const CommitMsgCommandConfig({required this.preset});
}
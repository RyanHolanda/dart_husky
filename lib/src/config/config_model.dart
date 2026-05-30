/// Represents the entire dart_husky.yaml config file
class GitHooksConfig {
  /// Map of hook types to their configurations
  final Map<HookType, HookConfig> hooks;

  /// Creates a [GitHooksConfig] with the given hooks
  const GitHooksConfig({required this.hooks});
}

/// All supported git hook types
enum HookType {
  /// Runs before a commit is created
  preCommit('pre-commit'),

  /// Validates the commit message format
  commitMsg('commit-msg'),

  /// Runs before pushing to remote
  prePush('pre-push'),

  /// Runs after switching branches
  postCheckout('post-checkout'),

  /// Runs before a merge commit
  preMergeCommit('pre-merge-commit');

  /// The filename used in .git/hooks/
  final String scriptName;

  const HookType(this.scriptName);

  /// Returns the [HookType] matching the given string, or null if not found
  static HookType? fromString(String value) {
    for (final type in HookType.values) {
      if (type.scriptName == value) return type;
    }
    return null;
  }
}

/// Represents one hook block in the config (e.g. pre-commit:)
class HookConfig {
  /// Whether to run commands in parallel (default: false)
  final bool parallel;

  /// Named shell commands to execute for this hook
  final Map<String, CommandConfig> commands;

  /// Named commit-msg commands — only used for [HookType.commitMsg]
  final Map<String, CommitMsgCommandConfig> msgCommands;

  /// Creates a [HookConfig] with the given commands
  const HookConfig({
    this.parallel = false,
    this.commands = const {},
    this.msgCommands = const {},
  });
}

/// Represents one named shell command inside a hook
class CommandConfig {
  /// The shell command to execute
  final String run;

  /// Optional glob pattern — only run if matching files are staged
  final String? glob;

  /// Creates a [CommandConfig] with the given run command
  const CommandConfig({required this.run, this.glob});
}

/// Specific to commit-msg hook — uses a preset instead of a shell command
class CommitMsgCommandConfig {
  /// The validation preset to use (e.g. 'conventional')
  final String preset;

  /// Creates a [CommitMsgCommandConfig] with the given preset
  const CommitMsgCommandConfig({required this.preset});
}

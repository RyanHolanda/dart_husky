/// Validates commit messages against the Conventional Commits specification.
///
/// See https://www.conventionalcommits.org for the full specification.
class CommitMsgValidator {
  /// Built-in valid commit types based on the Conventional Commits spec
  static const _builtInTypes = [
    'feat',
    'fix',
    'chore',
    'docs',
    'style',
    'refactor',
    'test',
    'build',
    'ci',
    'perf',
    'revert',
  ];

  /// Validates a commit message against the Conventional Commits format.
  ///
  /// Pass [appendTypes] to add custom types on top of built-in ones.
  /// Pass [overrideTypes] to replace built-in types entirely.
  ///
  /// Only the first line of the message is validated.
  ///
  /// Returns a [ValidationResult] indicating whether the message is valid.
  ///
  /// Example:
  /// ```dart
  /// final result = CommitMsgValidator.validate(
  ///   'feat(auth): add login',
  ///   appendTypes: ['wip', 'release'],
  /// );
  /// if (!result.passed) print(result.message);
  /// ```
  static ValidationResult validate(
    String message, {
    List<String> appendTypes = const [],
    List<String> overrideTypes = const [],
  }) {
    final validTypes = _resolveTypes(appendTypes, overrideTypes);
    final pattern = _buildPattern(validTypes);
    final firstLine = message.trim().split('\n').first;

    if (firstLine.isEmpty) {
      return ValidationResult.fail('Commit message cannot be empty.');
    }

    if (!pattern.hasMatch(firstLine)) {
      return ValidationResult.fail(
        'Commit message does not follow conventional commits format.\n'
        '\n'
        '  Expected: <type>(<scope>): <subject>\n'
        '  Got:      $firstLine\n'
        '\n'
        '  Valid types: ${validTypes.join(', ')}\n'
        '\n'
        '  Examples:\n'
        '    feat(auth): add login screen\n'
        '    fix: resolve null pointer exception\n'
        '    chore(deps): update dependencies\n',
      );
    }

    return ValidationResult.pass();
  }

  /// Resolves the final list of valid types based on append/override config
  static List<String> _resolveTypes(
    List<String> appendTypes,
    List<String> overrideTypes,
  ) {
    if (overrideTypes.isNotEmpty) return overrideTypes;
    if (appendTypes.isNotEmpty) return [..._builtInTypes, ...appendTypes];
    return _builtInTypes;
  }

  /// Builds the regex pattern from the given types list
  static RegExp _buildPattern(List<String> validTypes) {
    return RegExp(
      r'^(' + validTypes.join('|') + r')(?=\(|!|:)(\(.+\))?(!)?: .+',
    );
  }
}

/// The result of a commit message validation check.
class ValidationResult {
  /// Whether the validation passed
  final bool passed;

  /// The error message if validation failed, null if passed
  final String? message;

  const ValidationResult._({required this.passed, this.message});

  /// Creates a passing [ValidationResult]
  factory ValidationResult.pass() => const ValidationResult._(passed: true);

  /// Creates a failing [ValidationResult] with the given error [message]
  factory ValidationResult.fail(String message) =>
      ValidationResult._(passed: false, message: message);
}

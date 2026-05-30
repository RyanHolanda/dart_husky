/// Validates commit messages against the Conventional Commits specification.
///
/// See https://www.conventionalcommits.org for the full specification.
class CommitMsgValidator {
  /// List of valid commit types based on the Conventional Commits spec
  static const _validTypes = [
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

  /// Regex pattern matching: type(optional scope)!: subject
  static final _conventionalPattern = RegExp(
    r'^(' + _validTypes.join('|') + r')(\(.+\))?(!)?: .+',
  );

  /// Validates a commit message against the Conventional Commits format.
  ///
  /// Only the first line of the message is validated.
  ///
  /// Returns a [ValidationResult] indicating whether the message is valid.
  ///
  /// Example:
  /// ```dart
  /// final result = CommitMsgValidator.validate('feat(auth): add login');
  /// if (!result.passed) print(result.message);
  /// ```
  static ValidationResult validate(String message) {
    final firstLine = message.trim().split('\n').first;

    if (firstLine.isEmpty) {
      return ValidationResult.fail('Commit message cannot be empty.');
    }

    if (!_conventionalPattern.hasMatch(firstLine)) {
      return ValidationResult.fail(
        'Commit message does not follow conventional commits format.\n'
        '\n'
        '  Expected: <type>(<scope>): <subject>\n'
        '  Got:      $firstLine\n'
        '\n'
        '  Valid types: ${_validTypes.join(', ')}\n'
        '\n'
        '  Examples:\n'
        '    feat(auth): add login screen\n'
        '    fix: resolve null pointer exception\n'
        '    chore(deps): update dependencies\n',
      );
    }

    return ValidationResult.pass();
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

class CommitMsgValidator {
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

  // matches: type(optional scope): subject
  static final _conventionalPattern = RegExp(
    r'^(' + _validTypes.join('|') + r')(\(.+\))?(!)?: .+',
  );

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

class ValidationResult {
  final bool passed;
  final String? message;

  const ValidationResult._({required this.passed, this.message});

  factory ValidationResult.pass() => const ValidationResult._(passed: true);
  factory ValidationResult.fail(String message) =>
      ValidationResult._(passed: false, message: message);
}

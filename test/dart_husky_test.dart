import 'package:test/test.dart';
import 'package:dart_husky/src/config/config_model.dart';
import 'package:dart_husky/src/hooks/commit_msg_validator.dart';

void main() {
  group('CommitMsgValidator', () {
    group('valid messages', () {
      test('simple type and subject', () {
        final result = CommitMsgValidator.validate('feat: add login screen');
        expect(result.passed, isTrue);
      });

      test('type with scope', () {
        final result = CommitMsgValidator.validate(
          'fix(auth): resolve null pointer',
        );
        expect(result.passed, isTrue);
      });

      test('breaking change', () {
        final result = CommitMsgValidator.validate(
          'feat!: breaking api change',
        );
        expect(result.passed, isTrue);
      });

      test('breaking change with scope', () {
        final result = CommitMsgValidator.validate(
          'feat(api)!: breaking api change',
        );
        expect(result.passed, isTrue);
      });

      test('all valid types', () {
        final validTypes = [
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
          'bump',
        ];
        for (final type in validTypes) {
          final result = CommitMsgValidator.validate('$type: some subject');
          expect(result.passed, isTrue, reason: '$type should be valid');
        }
      });
    });

    group('invalid messages', () {
      test('empty message', () {
        final result = CommitMsgValidator.validate('');
        expect(result.passed, isFalse);
      });

      test('missing colon', () {
        final result = CommitMsgValidator.validate('feat add login screen');
        expect(result.passed, isFalse);
      });

      test('invalid type', () {
        final result = CommitMsgValidator.validate('update: something');
        expect(result.passed, isFalse);
      });

      test('missing subject', () {
        final result = CommitMsgValidator.validate('feat: ');
        expect(result.passed, isFalse);
      });

      test('no space after colon', () {
        final result = CommitMsgValidator.validate('feat:add login screen');
        expect(result.passed, isFalse);
      });
    });
  });

  group('HookType', () {
    test('fromString returns correct type', () {
      expect(HookType.fromString('pre-commit'), equals(HookType.preCommit));
      expect(HookType.fromString('commit-msg'), equals(HookType.commitMsg));
      expect(HookType.fromString('pre-push'), equals(HookType.prePush));
    });

    test('fromString returns null for unknown hook', () {
      expect(HookType.fromString('unknown-hook'), isNull);
    });

    test('scriptName matches git hook filename', () {
      expect(HookType.preCommit.scriptName, equals('pre-commit'));
      expect(HookType.commitMsg.scriptName, equals('commit-msg'));
      expect(HookType.prePush.scriptName, equals('pre-push'));
    });
  });
}

import '../../hooks/hook_runner.dart';

class RunCommand {
  Future<void> run(String hookName) async {
    await HookRunner.run(hookName);
  }
}
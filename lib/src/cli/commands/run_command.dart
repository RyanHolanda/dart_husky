import '../../hooks/hook_runner.dart';

class RunCommand {
  Future<void> run(String hookName, {String? arg}) async {
    await HookRunner.run(hookName, arg: arg);
  }
}

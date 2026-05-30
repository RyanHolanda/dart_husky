import '../../config/config_parser.dart';
import '../../hooks/hook_installer.dart';

class UninstallCommand {
  void run() {
    print('🗑️  Uninstalling dart_husky hooks...');
    final config = ConfigParser.parse();
    HookInstaller.uninstall(config);
    print('✅ All hooks removed successfully!');
  }
}

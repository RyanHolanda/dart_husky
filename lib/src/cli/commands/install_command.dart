import '../../config/config_parser.dart';
import '../../hooks/hook_installer.dart';

class InstallCommand {
  void run() {
    print('📦 Installing dart_husky hooks...');
    final config = ConfigParser.parse();
    HookInstaller.install(config);
    print('✅ All hooks installed successfully!');
  }
}

import '../../config/config_parser.dart';
import '../../hooks/hook_installer.dart';

class InstallCommand {
  void run() {
    print('📦 Installing dart_githooks hooks...');
    final config = ConfigParser.parse();
    HookInstaller.install(config);
    print('✅ All hooks installed successfully!');
  }
}
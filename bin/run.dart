import 'package:pip_services_accounts/pip_services_accounts.dart';

void main(List<String> argument) {
  try {
    var proc = AccountsProcess();
    proc.configPath = './config/config.yml';
    proc.run(argument);
  } catch (ex) {
    print(ex);
  }
}

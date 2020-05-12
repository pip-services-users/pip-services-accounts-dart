import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/AccountV1.dart';
import './AccountsMemoryPersistence.dart';

class AccountsFilePersistence extends AccountsMemoryPersistence {
  JsonFilePersister<AccountV1> persister;

  AccountsFilePersistence([String path]) : super() {
    persister = JsonFilePersister<AccountV1>(path);
    loader = persister;
    saver = persister;
  }
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    persister.configure(config);
  }
}

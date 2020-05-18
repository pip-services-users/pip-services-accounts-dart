import 'package:pip_services3_container/pip_services3_container.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

import '../build/AccountsServiceFactory.dart';

class AccountsProcess extends ProcessContainer {
  AccountsProcess() : super('accounts', 'User accounts microservice') {
    factories.add(AccountsServiceFactory());
    factories.add(DefaultRpcFactory());
  }
}

import 'package:pip_services3_rpc/pip_services3_rpc.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

class AccountsHttpServiceV1 extends CommandableHttpService {
  AccountsHttpServiceV1() : super('v1/accounts') {
    dependencyResolver.put('controller',
        Descriptor('pip-services-accounts', 'controller', '*', '*', '1.0'));
  }
}

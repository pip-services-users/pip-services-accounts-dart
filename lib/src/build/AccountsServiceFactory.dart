import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../persistence/AccountsMemoryPersistence.dart';
import '../persistence/AccountsFilePersistence.dart';
import '../persistence/AccountsMongoDbPersistence.dart';
import '../logic/AccountsController.dart';
import '../services/version1/AccountsHttpServiceV1.dart';

class AccountsServiceFactory extends Factory {
  static final MemoryPersistenceDescriptor =
      Descriptor('pip-services-accounts', 'persistence', 'memory', '*', '1.0');
  static final FilePersistenceDescriptor =
      Descriptor('pip-services-accounts', 'persistence', 'file', '*', '1.0');
  static final MongoDbPersistenceDescriptor =
      Descriptor('pip-services-accounts', 'persistence', 'mongodb', '*', '1.0');
  static final ControllerDescriptor =
      Descriptor('pip-services-accounts', 'controller', 'default', '*', '1.0');
  static final HttpServiceDescriptor =
      Descriptor('pip-services-accounts', 'service', 'http', '*', '1.0');

  AccountsServiceFactory() : super() {
    registerAsType(AccountsServiceFactory.MemoryPersistenceDescriptor,
        AccountsMemoryPersistence);
    registerAsType(AccountsServiceFactory.FilePersistenceDescriptor,
        AccountsFilePersistence);
    registerAsType(AccountsServiceFactory.MongoDbPersistenceDescriptor,
        AccountsMongoDbPersistence);
    registerAsType(
        AccountsServiceFactory.ControllerDescriptor, AccountsController);
    registerAsType(
        AccountsServiceFactory.HttpServiceDescriptor, AccountsHttpServiceV1);
  }
}

import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_accounts_dart/pip_services_accounts_dart.dart';
import './AccountsPersistenceFixture.dart';

void main() {
  group('AccountsMemoryPersistence', () {
    AccountsMemoryPersistence persistence;
    AccountsPersistenceFixture fixture;

    setUp(() async {
      persistence = AccountsMemoryPersistence();
      persistence.configure(ConfigParams());

      fixture = AccountsPersistenceFixture(persistence);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });

    test('Get with Filters', () async {
      await fixture.testGetWithFilters();
    });
  });
}

import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_accounts/pip_services_accounts.dart';

final ACCOUNT1 = AccountV1(
    id: '1',
    login: 'user1@conceptual.vision',
    name: 'Test User 1',
    deleted: false);
final ACCOUNT2 = AccountV1(
    id: '2',
    login: 'user2@conceptual.vision',
    name: 'Test User 2',
    deleted: false);
final ACCOUNT3 = AccountV1(
    id: '3',
    login: 'user3@conceptual.vision',
    name: 'Test User 3',
    deleted: false);

class AccountsPersistenceFixture {
  IAccountsPersistence _persistence;

  AccountsPersistenceFixture(IAccountsPersistence persistence) {
    expect(persistence, isNotNull);
    _persistence = persistence;
  }

  void _testCreateAccounts() async {
    // Create the first account
    var account = await _persistence.create(null, ACCOUNT1);

    expect(account, isNotNull);
    expect(ACCOUNT1.id, account.id);
    expect(ACCOUNT1.login, account.login);
    expect(ACCOUNT1.name, account.name);
    expect(account.active, true);

    // Create the second account
    account = await _persistence.create(null, ACCOUNT2);
    expect(account, isNotNull);
    expect(ACCOUNT2.id, account.id);
    expect(ACCOUNT2.login, account.login);
    expect(ACCOUNT2.name, account.name);
    expect(account.active, true);

    // Create the third account
    account = await _persistence.create(null, ACCOUNT3);
    expect(account, isNotNull);
    expect(ACCOUNT3.id, account.id);
    expect(ACCOUNT3.login, account.login);
    expect(ACCOUNT3.name, account.name);
    expect(account.active, true);
  }

  void testCrudOperations() async {
    AccountV1 account1;

    // Create items
    await _testCreateAccounts();

    // // Get all accounts
    var page = await _persistence.getPageByFilter(
        null, FilterParams(), PagingParams());
    expect(page, isNotNull);
    expect(page.data.length, 3);

    account1 = page.data[0];

    // Update the account
    account1.name = 'Updated User 1';

    var account = await _persistence.update(null, account1);
    expect(account, isNotNull);
    expect(account1.id, account.id);
    expect('Updated User 1', account.name);
    expect(account1.login, account.login);

    // Delete the account
    account = await _persistence.deleteById(null, account1.id);
    expect(account, isNotNull);
    expect(account1.id, account.id);

    // Try to get deleted account
    account = await _persistence.getOneById(null, account1.id);
    expect(account, isNull);
  }

  void testGetWithFilters() async {
    // Create items
    await _testCreateAccounts();

    // Get account filtered by active
    var page = await _persistence.getPageByFilter(
        null,
        FilterParams.fromValue({'active': true, 'search': 'user'}),
        PagingParams());
    expect(page.data.length, 3);

    // Get account by email
    var account = await _persistence.getOneByLogin(null, ACCOUNT2.login);
    expect(account, isNotNull);
    expect(ACCOUNT2.id, account.id);

    // Get account by id or email
    account = await _persistence.getOneByIdOrLogin(null, ACCOUNT3.login);
    expect(account, isNotNull);
    expect(ACCOUNT3.id, account.id);
  }
}

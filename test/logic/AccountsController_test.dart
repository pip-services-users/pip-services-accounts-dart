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

void main() {
  group('AccountsController', () {
    AccountsMemoryPersistence persistence;
    AccountsController controller;

    setUp(() async {
      persistence = AccountsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = AccountsController();
      controller.configure(ConfigParams());

      var references = References.fromTuples([
        Descriptor(
            'pip-services-accounts', 'persistence', 'memory', 'default', '1.0'),
        persistence,
        Descriptor(
            'pip-services-accounts', 'controller', 'default', 'default', '1.0'),
        controller
      ]);

      controller.setReferences(references);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('Create New User', () async {
      var account = await controller.createAccount(null, ACCOUNT1);
      expect(account, isNotNull);
      expect(ACCOUNT1.id, account.id);
      expect(ACCOUNT1.login, account.login);
      expect(ACCOUNT1.name, account.name);
    });

    test('Fail to Create Account with the Same Email', () async {
      // Sign up
      var account = await controller.createAccount(null, ACCOUNT1);
      expect(account, isNotNull);

      // Try to sign up again
      account = await controller.createAccount(null, ACCOUNT1);
      expect(account, isNull);
    });

    test('Get Accounts', () async {
      AccountV1 account1, account2;

      account1 = await controller.createAccount(null, ACCOUNT1);
      expect(account1, isNotNull);

      account2 = await controller.createAccount(null, ACCOUNT2);
      expect(account2, isNotNull);

      // Get a single account
      var account = await controller.getAccountById(null, account1.id);
      expect(account, isNotNull);
      expect(account1.id, account.id);
      expect(account1.login, account.login);
      expect(account1.name, account.name);

      // Find account by email
      account = await controller.getAccountByLogin(null, account2.login);
      expect(account, isNotNull);
      expect(account2.id, account.id);
      expect(account2.login, account.login);
      expect(account2.name, account.name);

      // Get all accounts
      var accounts =
          await controller.getAccounts(null, FilterParams(), PagingParams());
      expect(accounts, isNotNull);
      expect(accounts.data.length, 2);
    });

    test('Update Account', () async {
      AccountV1 account1;
      // Sign up
      account1 = await controller.createAccount(null, ACCOUNT1);
      expect(account1, isNotNull);

      // Update account
      account1.name = 'New Name';
      var account = await controller.updateAccount(null, account1);
      expect(account, isNotNull);
      expect('New Name', account.name);
    });

    test('Change Account Email', () async {
      AccountV1 account1;
      // Sign up
      account1 = await controller.createAccount(null, ACCOUNT1);
      expect(account1, isNotNull);

      // Change account email
      account1.login = 'test@test.com';
      account1.name = 'New Test Name';
      var account = await controller.updateAccount(null, account1);
      expect(account, isNotNull);
      expect('New Test Name', account.name);
      expect('test@test.com', account.login);
    });
  });
}

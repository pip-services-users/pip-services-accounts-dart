import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
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

var httpConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('AccountsHttpServiceV1', () {
    AccountsMemoryPersistence persistence;
    AccountsController controller;
    AccountsHttpServiceV1 service;
    http.Client rest;
    String url;

    setUp(() async {
      url = 'http://localhost:3000';
      rest = http.Client();

      persistence = AccountsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = AccountsController();
      controller.configure(ConfigParams());

      service = AccountsHttpServiceV1();
      service.configure(httpConfig);

      var references = References.fromTuples([
        Descriptor(
            'pip-services-accounts', 'persistence', 'memory', 'default', '1.0'),
        persistence,
        Descriptor(
            'pip-services-accounts', 'controller', 'default', 'default', '1.0'),
        controller,
        Descriptor(
            'pip-services-accounts', 'service', 'http', 'default', '1.0'),
        service
      ]);

      controller.setReferences(references);
      service.setReferences(references);

      await persistence.open(null);
      await service.open(null);
    });

    tearDown(() async {
      await service.close(null);
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      AccountV1 account1;

      // Create the first account
      var resp = await rest.post(url + '/v1/accounts/create_account',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'account': ACCOUNT1}));
      var account = AccountV1();
      account.fromJson(json.decode(resp.body));
      expect(account, isNotNull);
      expect(ACCOUNT1.id, account.id);
      expect(ACCOUNT1.login, account.login);
      expect(ACCOUNT1.name, account.name);
      expect(account.active, isTrue);

      // Create the second account
      resp = await rest.post(url + '/v1/accounts/create_account',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'account': ACCOUNT2}));
      account = AccountV1();
      account.fromJson(json.decode(resp.body));
      expect(account, isNotNull);
      expect(ACCOUNT2.id, account.id);
      expect(ACCOUNT2.login, account.login);
      expect(ACCOUNT2.name, account.name);
      expect(account.active, isTrue);

      // Create the second account
      resp = await rest.post(url + '/v1/accounts/create_account',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'account': ACCOUNT3}));
      account = AccountV1();
      account.fromJson(json.decode(resp.body));
      expect(account, isNotNull);
      expect(ACCOUNT3.id, account.id);
      expect(ACCOUNT3.login, account.login);
      expect(ACCOUNT3.name, account.name);
      expect(account.active, isTrue);

      // Get all accounts
      resp = await rest.post(url + '/v1/accounts/get_accounts',
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'filter': FilterParams(), 'paging': PagingParams()}));
      var page = DataPage<AccountV1>.fromJson(json.decode(resp.body), (item) {
        var account = AccountV1();
        account.fromJson(item);
        return account;
      });
      expect(page, isNotNull);
      expect(page.data.length, 3);

      account1 = page.data[0];

      // Update the account
      account1.name = 'Updated User 1';

      resp = await rest.post(url + '/v1/accounts/update_account',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'account': account1}));
      account = AccountV1();
      account.fromJson(json.decode(resp.body));
      expect(account, isNotNull);
      expect(account1.id, account.id);
      expect('Updated User 1', account.name);
      expect(account1.login, account.login);

      // Delete the account
      resp = await rest.post(url + '/v1/accounts/delete_account_by_id',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'account_id': account1.id}));
      account = AccountV1();
      account.fromJson(json.decode(resp.body));
      expect(account, isNotNull);
      expect(account1.id, account.id);

      // Try to get deleted account
      resp = await rest.post(url + '/v1/accounts/get_account_by_id',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'account_id': account1.id}));
      account = AccountV1();
      account.fromJson(json.decode(resp.body));
      expect(account, isNotNull);
      expect(account1.id, account.id);
      expect(account.deleted, isTrue);
    });
  });
}

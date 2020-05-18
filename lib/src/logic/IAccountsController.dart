import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../src/data/version1/AccountV1.dart';

abstract class IAccountsController {
  Future<DataPage<AccountV1>> getAccounts(
      String correlationId, FilterParams filter, PagingParams paging);

  Future<AccountV1> getAccountById(String correlationId, String id);

  Future<AccountV1> getAccountByLogin(String correlationId, String login);

  Future<AccountV1> getAccountByIdOrLogin(
      String correlationId, String idOrLogin);

  Future<AccountV1> createAccount(String correlationId, AccountV1 account);

  Future<AccountV1> updateAccount(String correlationId, AccountV1 account);

  Future<AccountV1> deleteAccountById(String correlationId, String accountId);
}

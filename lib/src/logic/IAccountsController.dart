import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../src/data/version1/AccountV1.dart';

abstract class IAccountsController {
  /// Gets a page of accounts retrieved by a given filter.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items
  /// - [paging]            (optional) paging parameters
  /// Return         Future that receives a data page
  /// Throws error.
  Future<DataPage<AccountV1>> getAccounts(
      String correlationId, FilterParams filter, PagingParams paging);

  /// Gets an account by its unique id.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of account to be retrieved.
  /// Return         Future that receives account or error.
  Future<AccountV1> getAccountById(String correlationId, String id);

  /// Gets an account by its login.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [login]                a login of account to be retrieved.
  /// Return         Future that receives account or error.
  Future<AccountV1> getAccountByLogin(String correlationId, String login);

  /// Gets an account by its unique id or login.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [idOrLogin]                an unique id or login of account to be retrieved.
  /// Return         Future that receives account or error.
  Future<AccountV1> getAccountByIdOrLogin(
      String correlationId, String idOrLogin);

  /// Creates an account.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [account]              an account to be created.
  /// Return         (optional) Future that receives created account or error.
  Future<AccountV1> createAccount(String correlationId, AccountV1 account);

  /// Updates an account.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [account]              an account to be updated.
  /// Return         (optional) Future that receives updated account
  /// Throws error.
  Future<AccountV1> updateAccount(String correlationId, AccountV1 account);

  /// Deleted an account by it's unique id.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of the account to be deleted
  /// Return                Future that receives deleted account
  /// Throws error.
  Future<AccountV1> deleteAccountById(String correlationId, String accountId);
}

import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

import '../../src/data/version1/AccountV1.dart';
import '../../src/persistence/IAccountsPersistence.dart';
import './IAccountsController.dart';
import './AccountsCommandSet.dart';

class AccountsController
    implements
        IAccountsController,
        IConfigurable,
        IReferenceable,
        ICommandable {
  static final RegExp _emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final ConfigParams _defaultConfig = ConfigParams.fromTuples([
    'dependencies.persistence',
    'pip-services-accounts:persistence:*:*:1.0',
    'dependencies.activities',
    'pip-services3-activities:client:*:*:1.0',
    'options.login_as_email',
    false
  ]);
  IAccountsPersistence persistence;
  AccountsCommandSet commandSet;
  DependencyResolver dependencyResolver =
      DependencyResolver(AccountsController._defaultConfig);
  final CompositeLogger _logger = CompositeLogger();
  // IActivitiesClient
  bool _loginAsEmail = false;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    config = config.setDefaults(AccountsController._defaultConfig);
    dependencyResolver.configure(config);

    _loginAsEmail =
        config.getAsBooleanWithDefault('options.login_as_email', _loginAsEmail);
  }

  /// Set references to component.
  ///
  /// - [references]    references parameters to be set.
  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
    dependencyResolver.setReferences(references);
    persistence =
        dependencyResolver.getOneRequired<IAccountsPersistence>('persistence');
    // activity client
  }

  /// Gets a command set.
  ///
  /// Return Command set
  @override
  CommandSet getCommandSet() {
    commandSet ??= AccountsCommandSet(this);
    return commandSet;
  }

  /// Gets a page of accounts retrieved by a given filter.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items
  /// - [paging]            (optional) paging parameters
  /// Return         Future that receives a data page
  /// Throws error.
  @override
  Future<DataPage<AccountV1>> getAccounts(
      String correlationId, FilterParams filter, PagingParams paging) {
    return persistence.getPageByFilter(correlationId, filter, paging);
  }

  /// Gets an account by its unique id.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of account to be retrieved.
  /// Return         Future that receives account or error.
  @override
  Future<AccountV1> getAccountById(String correlationId, String id) {
    return persistence.getOneById(correlationId, id);
  }

  /// Gets an account by its login.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [login]                a login of account to be retrieved.
  /// Return         Future that receives account or error.
  @override
  Future<AccountV1> getAccountByLogin(String correlationId, String login) {
    return persistence.getOneByLogin(correlationId, login);
  }

  /// Gets an account by its unique id or login.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [idOrLogin]                an unique id or login of account to be retrieved.
  /// Return         Future that receives account or error.
  @override
  Future<AccountV1> getAccountByIdOrLogin(
      String correlationId, String idOrLogin) {
    return persistence.getOneByIdOrLogin(correlationId, idOrLogin);
  }

  bool _validateAccount(String correlationId, AccountV1 account) {
    if (account.name == null) {
      var err =
          BadRequestException(correlationId, 'NO_NAME', 'Missing account name');
      _logger.trace(correlationId, 'Account is not valid %s', [err]);
      return false;
    }

    if (_loginAsEmail) {
      if (account.login == null) {
        var err = BadRequestException(
            correlationId, 'NO_EMAIL', 'Missing account primary email');
        _logger.trace(correlationId, 'Account is not valid %s', [err]);
        return false;
      }
    }

    if (!AccountsController._emailRegex.hasMatch(account.login)) {
      var err = BadRequestException(correlationId, 'WRONG_EMAIL',
              'Invalid account primary email ' + account.login)
          .withDetails('login', account.login);
      _logger.trace(correlationId, 'Account is not valid %s', [err]);
      return false;
    } else {
      if (account.login == null) {
        var err = BadRequestException(
            correlationId, 'NO_LOGIN', 'Missing account login');
        _logger.trace(correlationId, 'Account is not valid %s', [err]);
        return false;
      }
    }
    return true;
  }

  // logUserActivity()

  /// Creates an account.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [account]              an account to be created.
  /// Return         (optional) Future that receives created account or error.
  @override
  Future<AccountV1> createAccount(
      String correlationId, AccountV1 account) async {
    // Validate account
    if (!_validateAccount(correlationId, account)) {
      return null;
    }

    // Verify if account already registered
    var data = await persistence.getOneByLogin(correlationId, account.login);
    if (data != null) {
      var err = BadRequestException(correlationId, 'ALREADY_EXIST',
              'User account ' + account.login + ' is already exist')
          .withDetails('login', account.login);
      _logger.trace(correlationId, 'Account is not created %s', [err]);
      return null;
    }

    var created_account = await persistence.create(correlationId, account);
    // Log activity
    // logUserActivity()

    return created_account;
  }

  /// Updates an account.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [account]              an account to be updated.
  /// Return         (optional) Future that receives updated account
  /// Throws error.
  @override
  Future<AccountV1> updateAccount(
      String correlationId, AccountV1 account) async {
    AccountV1 oldAccount;

    // Validate account
    if (!_validateAccount(correlationId, account)) {
      return null;
    }

    // Verify if account with new login already registered
    oldAccount = await persistence.getOneByLogin(correlationId, account.login);
    if (oldAccount != null && oldAccount.id != account.id) {
      var err = BadRequestException(correlationId, 'ALREADY_EXIST',
              'User account ' + account.login + ' is already exist')
          .withDetails('login', account.login);
      _logger.trace(correlationId, 'Account is not updated %s', [err]);
      return null;
    }

    if (oldAccount == null) {
      var err = BadRequestException(correlationId, 'NOT_FOUND',
              'User account ' + account.id + ' was not found')
          .withDetails('id', account.id);
      _logger.trace(correlationId, 'Account is not updated %s', [err]);
      return null;
    }

    var updated_account = await persistence.update(correlationId, account);
    // Log activity
    // logUserActivity()
    return updated_account;
  }

  /// Deleted an account by it's unique id.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [id]                an id of the account to be deleted
  /// Return                Future that receives deleted account
  /// Throws error.
  @override
  Future<AccountV1> deleteAccountById(String correlationId, String id) async {
    AccountV1 oldAccount;
    AccountV1 newAccount;

    oldAccount = await persistence.getOneById(correlationId, id);
    if (oldAccount == null) {
      return null;
    }

    newAccount = oldAccount;
    newAccount.deleted = true;
    await persistence.update(correlationId, newAccount);

    if (oldAccount != null) {
      // logUserActivity()
    }

    return newAccount;
  }
}

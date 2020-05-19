import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../src/data/version1/AccountV1Schema.dart';
import '../../src/logic/IAccountsController.dart';
import '../../src/data/version1/AccountV1.dart';

class AccountsCommandSet extends CommandSet {
  IAccountsController _controller;

  AccountsCommandSet(IAccountsController controller) : super() {
    _controller = controller;

    addCommand(_makeGetAccountsCommand());
    addCommand(_makeGetAccountByIdCommand());
    addCommand(_makeGetAccountByLoginCommand());
    addCommand(_makeGetAccountByIdOrLoginCommand());
    addCommand(_makeCreateAccountCommand());
    addCommand(_makeUpdateAccountCommand());
    addCommand(_makeDeleteAccountByIdCommand());
  }

  ICommand _makeGetAccountsCommand() {
    return Command(
        'get_accounts',
        ObjectSchema(true)
            .withOptionalProperty('filter', FilterParamsSchema())
            .withOptionalProperty('paging', PagingParamsSchema()),
        (String correlationId, Parameters args) {
      var filter = FilterParams.fromValue(args.get('filter'));
      var paging = PagingParams.fromValue(args.get('paging'));
      return _controller.getAccounts(correlationId, filter, paging);
    });
  }

  ICommand _makeGetAccountByIdCommand() {
    return Command('get_account_by_id',
        ObjectSchema(true).withRequiredProperty('account_id', TypeCode.String),
        (String correlationId, Parameters args) {
      var accountId = args.getAsString('account_id');
      return _controller.getAccountById(correlationId, accountId);
    });
  }

  ICommand _makeGetAccountByLoginCommand() {
    return Command('get_account_by_login',
        ObjectSchema(true).withRequiredProperty('login', TypeCode.String),
        (String correlationId, Parameters args) {
      var login = args.getAsString('login');
      return _controller.getAccountByLogin(correlationId, login);
    });
  }

  ICommand _makeGetAccountByIdOrLoginCommand() {
    return Command('get_account_by_id_or_login',
        ObjectSchema(true).withRequiredProperty('id_or_login', TypeCode.String),
        (String correlationId, Parameters args) {
      var idOrLogin = args.getAsString('id_or_login');
      return _controller.getAccountByIdOrLogin(correlationId, idOrLogin);
    });
  }

  ICommand _makeCreateAccountCommand() {
    return Command(
        'create_account',
        ObjectSchema(true)
            .withRequiredProperty('account', null), //AccountV1Schema()
        (String correlationId, Parameters args) {
      var account = AccountV1();
      account.fromJson(args.get('account'));
      return _controller.createAccount(correlationId, account);
    });
  }

  ICommand _makeUpdateAccountCommand() {
    return Command('update_account',
        ObjectSchema(true).withRequiredProperty('account', AccountV1Schema()),
        (String correlationId, Parameters args) {
      var account = AccountV1();
      account.fromJson(args.get('account'));
      return _controller.updateAccount(correlationId, account);
    });
  }

  ICommand _makeDeleteAccountByIdCommand() {
    return Command('delete_account_by_id',
        ObjectSchema(true).withRequiredProperty('account_id', TypeCode.String),
        (String correlationId, Parameters args) {
      var accountId = args.getAsString('account_id');
      return _controller.deleteAccountById(correlationId, accountId);
    });
  }
}

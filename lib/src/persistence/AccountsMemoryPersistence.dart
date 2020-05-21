import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';
import '../data/version1/AccountV1.dart';
import './IAccountsPersistence.dart';

class AccountsMemoryPersistence
    extends IdentifiableMemoryPersistence<AccountV1, String>
    implements IAccountsPersistence {
  AccountsMemoryPersistence() : super() {
    maxPageSize = 1000;
  }

  bool matchString(String value, String search) {
    if (value == null && search == null) {
      return true;
    }
    if (value == null || search == null) {
      return false;
    }
    return value.toLowerCase().contains(search);
  }

  bool matchSearch(AccountV1 item, String search) {
    search = search.toLowerCase();
    if (matchString(item.name, search)) {
      return true;
    }
    if (matchString(item.login, search)) {
      return true;
    }
    return false;
  }

  Function composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();

    var search = filter.getAsNullableString('search');
    var id = filter.getAsNullableString('id');
    var ids = filter.getAsObject('ids');
    var name = filter.getAsNullableString('name');
    var login = filter.getAsNullableString('login');
    var active = filter.getAsNullableBoolean('active');
    var fromCreateTime = filter.getAsNullableDateTime('from_create_time');
    var toCreateTime = filter.getAsNullableDateTime('to_create_time');
    var deleted = filter.getAsBooleanWithDefault('deleted', false);

    if (ids != null && ids is String) {
      ids = (ids as String).split(',');
    }
    if (ids != null && !(ids is List)) {
      ids = null;
    }

    return (item) {
      if (search != null && !matchSearch(item, search)) {
        return false;
      }
      if (id != null && item.id != id) {
        return false;
      }
      if (name != null && item.name != name) {
        return false;
      }
      if (login != null && item.login != login) {
        return false;
      }
      if (active != null && item.active != active) {
        return false;
      }
      if (fromCreateTime != null && item.create_time >= fromCreateTime) {
        return false;
      }
      if (toCreateTime != null && item.create_time < toCreateTime) {
        return false;
      }
      if (!deleted && item.deleted != null && item.deleted) {
        return false;
      }
      if (ids != null && !(ids as List).contains(item.id)) {
        return false;
      }
      return true;
    };
  }

  @override
  Future<DataPage<AccountV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) {
    return super
        .getPageByFilterEx(correlationId, composeFilter(filter), paging, null);
  }

  @override
  Future<AccountV1> getOneByLogin(String correlationId, String login) async {
    var item =
        items.isNotEmpty ? items.where((item) => item.login == login) : null;

    if (item != null && item.isNotEmpty && item.first != null) {
      logger.trace(correlationId, 'Found account by %s', [login]);
    } else {
      logger.trace(correlationId, 'Cannot find account by %s', [login]);
    }

    if (item != null && item.isNotEmpty && item.first != null) {
      return item.first;
    } else {
      return null;
    }
  }

  @override
  Future<AccountV1> getOneByIdOrLogin(
      String correlationId, String idOrLogin) async {
    var item = items.isNotEmpty
        ? items.where((item) => item.id == idOrLogin || item.login == idOrLogin)
        : null;

    if (item != null && item.isNotEmpty && item.first != null) {
      logger.trace(correlationId, 'Found account by %s', [idOrLogin]);
    } else {
      logger.trace(correlationId, 'Cannot find account by %s', [idOrLogin]);
    }

    if (item != null && item.isNotEmpty && item.first != null) {
      return item.first;
    } else {
      return null;
    }
  }

  @override
  Future<AccountV1> create(String correlationId, AccountV1 item) async {
    var existingItem = items.isNotEmpty
        ? items.where((element) => element.login == item.login)
        : null;
    if (existingItem != null &&
        existingItem.isNotEmpty &&
        existingItem.first != null) {
      var err = BadRequestException(correlationId, 'ALREADY_EXIST',
              'User account ' + item.login + ' already exist')
          .withDetails('login', item.login);
      logger.trace(correlationId, 'Create account error %s', [err]);
      return null;
    }

    item.active = item.active ?? true;
    item.create_time = DateTime.now();

    return super.create(correlationId, item);
  }
}

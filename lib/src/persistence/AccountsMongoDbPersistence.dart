import 'dart:async';
import 'package:mongo_dart_query/mongo_dart_query.dart' as mngquery;
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_mongodb/pip_services3_mongodb.dart';

import '../data/version1/AccountV1.dart';
import './IAccountsPersistence.dart';

class AccountsMongoDbPersistence
    extends IdentifiableMongoDbPersistence<AccountV1, String>
    implements IAccountsPersistence {
  AccountsMongoDbPersistence() : super('accounts') {
    maxPageSize = 1000;
    super.ensureIndex({'login': 1}, unique: true);
  }

  dynamic composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();

    var criteria = [];

    var search = filter.getAsNullableString('search');
    if (search != null) {
      var searchRegex = RegExp(r'^' + search, caseSensitive: false);
      var searchCriteria = [];
      searchCriteria.add({
        'login': {r'$regex': searchRegex.pattern}
      });
      searchCriteria.add({
        'name': {r'$regex': searchRegex.pattern}
      });
      criteria.add({r'$or': searchCriteria});
    }

    var id = filter.getAsNullableString('id');
    if (id != null) {
      criteria.add({'_id': id});
    }

    var ids = filter.getAsObject('ids');
    if (ids is String) {
      ids = (ids as String).split(',');
    }
    if (ids is List) {
      criteria.add({
        '_id': {r'$in': ids}
      });
    }

    var name = filter.getAsNullableString('name');
    if (name != null) {
      criteria.add({'name': name});
    }

    var login = filter.getAsNullableString('login');
    if (login != null) {
      criteria.add({'login': login});
    }

    var active = filter.getAsNullableBoolean('active');
    if (active != null) {
      criteria.add({'active': active});
    }

    var toTime = filter.getAsNullableDateTime('to_create_time');
    if (toTime != null) {
      criteria.add({
        'create_time': {r'$lt': toTime}
      });
    }

    var fromTime = filter.getAsNullableDateTime('from_create_time');
    if (fromTime != null) {
      criteria.add({
        'create_time': {r'$gte': fromTime}
      });
    }

    var deleted = filter.getAsBooleanWithDefault('deleted', false);
    if (!deleted) {
      criteria.add({
        r'$or': [
          {'deleted': false},
          {
            'deleted': {r'$exists': false}
          }
        ]
      });
    }

    return criteria.isNotEmpty ? {r'$and': criteria} : null;
  }

  @override
  Future<DataPage<AccountV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) async {
    return super.getPageByFilterEx(correlationId, composeFilter(filter), paging,
        null); //{'-create_time': { 'custom_dat': 0 }}
  }

  @override
  Future<AccountV1> getOneByLogin(String correlationId, String login) async {
    var filter = {'login': login};
    var query = mngquery.SelectorBuilder();
    var selector = <String, dynamic>{};
    if (filter != null && filter.isNotEmpty) {
      selector[r'$query'] = filter;
    }
    query.raw(selector);

    var item = await collection.findOne(filter);

    if (item == null) {
      logger.trace(correlationId, 'Nothing found from %s with login = %s',
          [collectionName, login]);
      return null;
    }
    logger.trace(correlationId, 'Retrieved from %s with login = %s',
        [collectionName, login]);
    return convertToPublic(item);
  }

  @override
  Future<AccountV1> getOneByIdOrLogin(
      String correlationId, String idOrLogin) async {
    var filter = {
      r'$or': [
        {'login': idOrLogin},
        {'_id': idOrLogin}
      ]
    };
    var query = mngquery.SelectorBuilder();
    var selector = <String, dynamic>{};
    if (filter != null && filter.isNotEmpty) {
      selector[r'$query'] = filter;
    }
    query.raw(selector);

    var item = await collection.findOne(selector);

    if (item == null) {
      logger.trace(correlationId, 'Nothing found from %s with idOrLogin = %s',
          [collectionName, idOrLogin]);
      return null;
    }
    logger.trace(correlationId, 'Retrieved from %s with idOrLogin = %s',
        [collectionName, idOrLogin]);
    return convertToPublic(item);
  }

  @override
  Future<AccountV1> create(String correlationId, AccountV1 item) async {
    item.active = item.active ?? true;
    item.create_time = item.create_time ?? DateTime.now();

    return super.create(correlationId, item);
  }
}

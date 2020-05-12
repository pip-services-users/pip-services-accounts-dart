import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/AccountV1.dart';

abstract class IAccountsPersistence {
  Future<DataPage<AccountV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging);

  Future<AccountV1> getOneById(String correlationId, String id);

  Future<AccountV1> getOneByLogin(String correlationId, String login);

  Future<AccountV1> getOneByIdOrLogin(String correlationId, String idOrLogin);

  Future<AccountV1> create(String correlationId, AccountV1 item);

  Future<AccountV1> update(String correlationId, AccountV1 item);

  Future<AccountV1> deleteById(String correlationId, String id);
}
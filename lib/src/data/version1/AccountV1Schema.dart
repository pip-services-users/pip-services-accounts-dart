import 'package:pip_services3_commons/pip_services3_commons.dart';

class AccountV1Schema extends ObjectSchema {
  AccountV1Schema() : super() {
    withOptionalProperty('id', TypeCode.String);
    withRequiredProperty('login', TypeCode.String);
    withRequiredProperty('name', TypeCode.String);
    withOptionalProperty('create_time', TypeCode.DateTime);
    withOptionalProperty('deleted', TypeCode.Boolean);
    withOptionalProperty('active', TypeCode.Boolean);
    withOptionalProperty('about', TypeCode.String);
    withOptionalProperty('time_zone', TypeCode.String);
    withOptionalProperty('language', TypeCode.String);
    withOptionalProperty('theme', TypeCode.String);
    withOptionalProperty('custom_hdr', null);
    withOptionalProperty('custom_dat', null);
  }
}

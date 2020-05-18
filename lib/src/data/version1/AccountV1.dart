import 'package:pip_services3_commons/pip_services3_commons.dart';

class AccountV1 implements IStringIdentifiable {
  @override
  /* Identification */
  String id;
  String login;
  String name;

  /* Activity tracking */
  DateTime create_time;
  bool deleted;
  bool active;

  /* User preferences */
  String about;
  String time_zone;
  String language;
  String theme;

  /* Custom fields */
  var custom_hdr;
  var custom_dat;

  AccountV1(
      {String id,
      String login,
      String name,
      DateTime create_time,
      bool deleted,
      bool active,
      String about,
      String time_zone,
      String language,
      String theme,
      var custom_hdr,
      var custom_dat})
      : id = id,
        login = login,
        name = name,
        create_time = create_time,
        deleted = deleted,
        active = active,
        about = about,
        time_zone = time_zone,
        language = language,
        theme = theme,
        custom_hdr = custom_hdr,
        custom_dat = custom_dat;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    name = json['name'];
    var create_time_json = json['create_time'];
    create_time = create_time_json != null
        ? DateTime.tryParse(json['create_time'])
        : null;
    deleted = json['deleted'];
    active = json['active'];
    about = json['about'];
    time_zone = json['time_zone'];
    language = json['language'];
    theme = json['theme'];
    custom_hdr = json['custom_hdr'];
    custom_dat = json['custom_dat'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'login': login,
      'name': name,
      'create_time':
          create_time != null ? create_time.toIso8601String() : create_time,
      'deleted': deleted,
      'active': active,
      'about': about,
      'time_zone': time_zone,
      'language': language,
      'theme': theme,
      'custom_hdr': custom_hdr,
      'custom_dat': custom_dat
    };
  }
}

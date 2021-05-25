import 'package:drambase/drambase.dart';
import 'package:drambase/src/database/field.dart';
import 'package:drambase/src/database/model.dart';
import 'package:drambase/src/database/database.dart';
import 'package:drambase/src/query/query.dart';

import 'user.dart';

part 'user.g.dart';

class AppDatabase extends Database<AppDatabase> {
  static final AppDatabase _instance = AppDatabase._(); 

  AppDatabase._();

  factory AppDatabase() {
    return _instance;
  }

  /// The users database table
  UsersTable get users => UsersTable._instance;

}
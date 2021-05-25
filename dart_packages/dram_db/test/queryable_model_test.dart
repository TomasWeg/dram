

import 'package:drambase/src/query/query.dart';

import 'user.g.dart';

void main() {
  // var database = MyDatabase();
  // var model = database.select((model) => model.users);
  var users = UsersTable();
  users.name.isEqualsTo('Tomas');
}
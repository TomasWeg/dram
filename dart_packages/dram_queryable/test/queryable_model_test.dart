
import 'package:dram_queryable/dram_queryable.dart';

import 'user.g.dart';

void main() {
  var database = MyDatabase();
  var model = database.select((model) => model.users);
}
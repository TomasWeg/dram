import 'user.g.dart';

void main() {
  var database = MyDatabase();
  var model = database.select((model) => model.users);
  model.where((queryable) => 
    queryable
    .name.isNotEqualsTo('tomas')
    .and()
    // .age.isGreaterThan(18)
    .phoneNumber.country.isEqualsTo('Argentina')
    );

  // model.filter((filter) => {
  //   filter.where((x) => x.name).isEqualsTo('Tomas')
  // });
}
import 'package:test/test.dart';
import 'package:dram_queryable/src/query_builder/query_builder.dart';

void main() {
  test('QueryModel from scratch', () {
    var query = UserQuery();
    query.where((model) => model.age.isEqualsTo(20));
  });
}

class User {
  final String id, name, surname;
  final int age;
  final DateTime registeredDate;
  final bool isEnabled;
  final Address address;

  User({required this.id, required this.name, required this.surname, required this.age, required this.registeredDate, required this.isEnabled, required this.address});
}

class Address {
  final String street;
  final int streetNumber;

  Address({required this.street, required this.streetNumber});
}

class UserModel extends QueryModel<User> {
  UserModel() : super([
    StringQueryProperty('id'),
    StringQueryProperty('name'),  
    StringQueryProperty('surname'),  
    IntQueryProperty('age'),  
    BoolQueryProperty('isEnabled'),  
    AddressModel(),  
  ]);

  StringQueryProperty get id => properties[0] as StringQueryProperty;
  StringQueryProperty get name => properties[1] as StringQueryProperty;
  StringQueryProperty get surname => properties[2] as StringQueryProperty;
  IntQueryProperty get age => properties[3] as IntQueryProperty;
  BoolQueryProperty get isEnabled => properties[4] as BoolQueryProperty;
  AddressModel get address => properties[5] as AddressModel;

}

class AddressModel extends QueryModel<Address> {
  AddressModel() : super([
    StringQueryProperty('street'),
    IntQueryProperty('streetNumber')
  ]);

  StringQueryProperty get street => properties[0] as StringQueryProperty;
  IntQueryProperty get streetNumber => properties[1] as IntQueryProperty;
}

class UserQuery extends QueryBuilder<User, UserModel> {

}
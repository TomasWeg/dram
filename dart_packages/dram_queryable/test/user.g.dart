/* THIS WILL BE A GENERATED FILE */
import 'package:dram_queryable/dram_queryable.dart';

import 'user.dart';

class MyDatabase extends Database<MyDatabaseModel> {
  MyDatabase() : super(MyDatabaseModel._());
}

class MyDatabaseModel extends DatabaseModel {
  MyDatabaseModel._();

  static final List<QueryableModel> _models = [
    UserModel._(),
  ];

  UserModel get users => _models[0] as UserModel; 
}

class UserModel extends QueryableModel<User> {

  UserModel._() : super('users');
  static final UserModel _instance = UserModel._();

  static final List<Queryable> _properties = [
    StringQueryableProperty('id'),
    StringQueryableProperty('name'),
    StringQueryableProperty('lastName'),
    IntQueryableProperty('age'),
    DoubleQueryableProperty('points'),
    ListQueryableProperty<Address>('addresses'),
    PhoneNumberModel._()
  ];

  StringQueryableProperty get id => _properties[0] as StringQueryableProperty;
  QueryableProperty<String> get name => _properties[1] as StringQueryableProperty;
  StringQueryableProperty get lastName => _properties[2] as StringQueryableProperty;
  IntQueryableProperty get age => _properties[3] as IntQueryableProperty;
  DoubleQueryableProperty get points => _properties[4] as DoubleQueryableProperty;
  ListQueryableProperty<Address> get addresses => _properties[5] as ListQueryableProperty<Address>;
  PhoneNumberModel get phoneNumber => _properties[6] as PhoneNumberModel;
}

class AddressModel extends QueryableModel<Address> {
  static final AddressModel _instance = AddressModel._();
  AddressModel._() : super('addresses');

  static final List<Queryable> _properties = [
    StringQueryableProperty('street'),
    IntQueryableProperty('streetNumber'),
    CoordinatesModel._()
  ];

  StringQueryableProperty get street => _properties[0] as StringQueryableProperty;
  IntQueryableProperty get streetNumber => _properties[1] as IntQueryableProperty;
  CoordinatesModel get coordinates => _properties[2] as CoordinatesModel;
}

class CoordinatesModel extends QueryableModel<Coordinates> {
  static final CoordinatesModel _instance = CoordinatesModel._();
  CoordinatesModel._() : super('coordinates');
  
  static final List<Queryable> _properties = [
    DoubleQueryableProperty('latitude'),
    DoubleQueryableProperty('longitude'),
  ];

  DoubleQueryableProperty get latitude => _properties[0] as DoubleQueryableProperty;
  DoubleQueryableProperty get longitude => _properties[1] as DoubleQueryableProperty;
}

class PhoneNumberModel extends QueryableModel<PhoneNumber> {
  PhoneNumberModel._() : super('phoneNumber');
  static final PhoneNumberModel _instance = PhoneNumberModel._();

  static final List<Queryable> _properties = [
    StringQueryableProperty('prefix'),
    StringQueryableProperty('number'),
    StringQueryableProperty('country'),  
  ];


  StringQueryableProperty get prefix => _properties[0] as StringQueryableProperty;
  StringQueryableProperty get number => _properties[1] as StringQueryableProperty;
  StringQueryableProperty get country => _properties[2] as StringQueryableProperty;
}
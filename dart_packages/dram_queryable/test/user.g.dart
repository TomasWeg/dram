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
    StringQueryableProperty<User, UserModel>('id', _instance),
    StringQueryableProperty<User, UserModel>('name', _instance),
    StringQueryableProperty<User, UserModel>('lastName', _instance),
    IntQueryableProperty<User, UserModel>('age', _instance),
    DoubleQueryableProperty<User, UserModel>('points', _instance),
    ListQueryableProperty<Address, User, UserModel>('addresses', _instance),
    PhoneNumberModel._()
  ];

  StringQueryableProperty<User, UserModel> get id => _properties[0] as StringQueryableProperty<User, UserModel>;
  StringQueryableProperty<User, UserModel> get name => _properties[1] as StringQueryableProperty<User, UserModel>;
  StringQueryableProperty<User, UserModel> get lastName => _properties[2] as StringQueryableProperty<User, UserModel>;
  IntQueryableProperty<User, UserModel> get age => _properties[3] as IntQueryableProperty<User, UserModel>;
  DoubleQueryableProperty<User, UserModel> get points => _properties[4] as DoubleQueryableProperty<User, UserModel>;
  ListQueryableProperty<Address, User, UserModel> get addresses => _properties[5] as ListQueryableProperty<Address, User, UserModel>;
  PhoneNumberModel get phoneNumber => _properties[6] as PhoneNumberModel;
}

class AddressModel extends QueryableModel<Address> {
  static final AddressModel _instance = AddressModel._();
  AddressModel._() : super('addresses');

  static final List<Queryable> _properties = [
    StringQueryableProperty<Address, AddressModel>('street', _instance),
    IntQueryableProperty<Address, AddressModel>('streetNumber', _instance),
    CoordinatesModel._()
  ];

  StringQueryableProperty<Address, AddressModel> get street => _properties[0] as StringQueryableProperty<Address, AddressModel>;
  IntQueryableProperty<Address, AddressModel> get streetNumber => _properties[1] as IntQueryableProperty<Address, AddressModel>;
  CoordinatesModel get coordinates => _properties[2] as CoordinatesModel;
}

class CoordinatesModel extends QueryableModel<Coordinates> {
  static final CoordinatesModel _instance = CoordinatesModel._();
  CoordinatesModel._() : super('coordinates');
  
  static final List<Queryable> _properties = [
    DoubleQueryableProperty<Coordinates, CoordinatesModel>('latitude', _instance),
    DoubleQueryableProperty<Coordinates, CoordinatesModel>('longitude', _instance),
  ];

  DoubleQueryableProperty<Coordinates, CoordinatesModel> get latitude => _properties[0] as DoubleQueryableProperty<Coordinates, CoordinatesModel>;
  DoubleQueryableProperty<Coordinates, CoordinatesModel> get longitude => _properties[1] as DoubleQueryableProperty<Coordinates, CoordinatesModel>;
}

class PhoneNumberModel extends QueryableModel<PhoneNumber> {
  PhoneNumberModel._() : super('phoneNumber');
  static final PhoneNumberModel _instance = PhoneNumberModel._();

  static final List<Queryable> _properties = [
    StringQueryableProperty<PhoneNumber, PhoneNumberModel>('prefix', _instance),
    StringQueryableProperty<PhoneNumber, PhoneNumberModel>('number', _instance),
    StringQueryableProperty<PhoneNumber, PhoneNumberModel>('country', _instance),  
  ];


  StringQueryableProperty<PhoneNumber, PhoneNumberModel> get prefix => _properties[0] as StringQueryableProperty<PhoneNumber, PhoneNumberModel>;
  StringQueryableProperty<PhoneNumber, PhoneNumberModel> get number => _properties[1] as StringQueryableProperty<PhoneNumber, PhoneNumberModel>;
  StringQueryableProperty<PhoneNumber, PhoneNumberModel> get country => _properties[2] as StringQueryableProperty<PhoneNumber, PhoneNumberModel>;
}
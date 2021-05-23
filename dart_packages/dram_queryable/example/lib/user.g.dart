/* THIS WILL BE A GENERATED FILE */
import 'package:dram_queryable/dram_queryable.dart';
import 'package:example/user.dart';

class MyDatabase extends Database<MyDatabaseModel> {
  MyDatabase() : super(MyDatabaseModel._());
}

class MyDatabaseModel extends DatabaseModel {
  MyDatabaseModel._();

  static const List<QueryableModel> _models = [
    UserModel._(),
  ];

  UserModel get users => _models[0] as UserModel; 
}

class UserModel extends QueryableModel<User> {

  static const List<Queryable> _properties = [
    StringQueryableProperty('id'),
    StringQueryableProperty('name'),
    StringQueryableProperty('lastName'),
    IntQueryableProperty('age'),
    DoubleQueryableProperty('points'),
    ListQueryableProperty<Address>('addresses'),
    PhoneNumberModel._()
  ];

  const UserModel._() : super("users");

  StringQueryableProperty get id => _properties[0] as StringQueryableProperty;
  StringQueryableProperty get name => _properties[1] as StringQueryableProperty;
  StringQueryableProperty get lastName => _properties[2] as StringQueryableProperty;
  IntQueryableProperty get age => _properties[3] as IntQueryableProperty;
  DoubleQueryableProperty get points => _properties[4] as DoubleQueryableProperty;
  ListQueryableProperty<Address> get addresses => _properties[5] as ListQueryableProperty<Address>;
  PhoneNumberModel get phoneNumber => _properties[6] as PhoneNumberModel;
}

class AddressModel extends QueryableModel<Address> {
  static const List<Queryable> _properties = [
    StringQueryableProperty('street'),
    IntQueryableProperty('streetNumber'),
    CoordinatesModel._()
  ];

  const AddressModel._() : super("addresses");

  StringQueryableProperty get street => _properties[0] as StringQueryableProperty;
  IntQueryableProperty get streetNumber => _properties[1] as IntQueryableProperty;
  CoordinatesModel get coordinates => _properties[2] as CoordinatesModel;
}

class CoordinatesModel extends QueryableModel<Coordinates> {
  static const List<Queryable> _properties = [
    DoubleQueryableProperty('latitude'),
    DoubleQueryableProperty('longitude'),
  ];
  const CoordinatesModel._() : super("coordinates");

  DoubleQueryableProperty get latitude => _properties[0] as DoubleQueryableProperty;
  DoubleQueryableProperty get longitude => _properties[1] as DoubleQueryableProperty;
}

class PhoneNumberModel extends QueryableModel<PhoneNumber> {
  static const List<Queryable> _properties = [
    StringQueryableProperty('prefix'),
    StringQueryableProperty('number'),
    StringQueryableProperty('country'),  
  ];

  const PhoneNumberModel._() : super('phoneNumber');

  StringQueryableProperty get prefix => _properties[0] as StringQueryableProperty;
  StringQueryableProperty get number => _properties[1] as StringQueryableProperty;
  StringQueryableProperty get country => _properties[2] as StringQueryableProperty;
}
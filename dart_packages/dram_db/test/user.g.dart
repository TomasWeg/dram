/* THIS WILL BE A GENERATED FILE */
import 'package:drambase/src/database/field.dart';
import 'package:drambase/src/database/model.dart';
import 'package:drambase/src/database/table.dart';
import 'package:drambase/src/query/query.dart';

import 'user.dart';

class UserTable extends DatabaseTable<User> {

  UserTable._() : super('users');
  static final UserTable _instance = UserTable._();

  static final List<Queryable> _properties = [
    StringTableField('id'),
    StringTableField('name'),
    StringTableField('lastName'),
    IntTableField('age'),
    DoubleTableField('points'),
    ListTableField<Address>('addresses'),
    PhoneNumberModel._()
  ];

  StringTableField get id => _properties[0] as StringTableField;
  StringTableField get name => _properties[1] as StringTableField;
  StringTableField get lastName => _properties[2] as StringTableField;
  IntTableField get age => _properties[3] as IntTableField;
  DoubleTableField get points => _properties[4] as DoubleTableField;
  ListTableField<Address> get addresses => _properties[5] as ListTableField<Address>;
  PhoneNumberModel get phoneNumber => _properties[6] as PhoneNumberModel;
}

class AddressModel extends DatabaseModel<Address> {
  static final AddressModel _instance = AddressModel._();
  AddressModel._() : super('addresses');

  static final List<Queryable> _properties = [
    StringTableField('street'),
    IntTableField('streetNumber'),
    CoordinatesModel._()
  ];

  StringTableField get street => _properties[0] as StringTableField;
  IntTableField get streetNumber => _properties[1] as IntTableField;
  CoordinatesModel get coordinates => _properties[2] as CoordinatesModel;
}

class CoordinatesModel extends DatabaseModel<Coordinates> {
  static final CoordinatesModel _instance = CoordinatesModel._();
  CoordinatesModel._() : super('coordinates');
  
  static final List<Queryable> _properties = [
    DoubleTableField('latitude'),
    DoubleTableField('longitude'),
  ];

  DoubleTableField get latitude => _properties[0] as DoubleTableField;
  DoubleTableField get longitude => _properties[1] as DoubleTableField;
}

class PhoneNumberModel extends DatabaseModel<PhoneNumber> {
  PhoneNumberModel._() : super('phoneNumber');
  static final PhoneNumberModel _instance = PhoneNumberModel._();

  static final List<Queryable> _properties = [
    StringTableField('prefix'),
    StringTableField('number'),
    StringTableField('country'),  
  ];


  StringTableField get prefix => _properties[0] as StringTableField;
  StringTableField get number => _properties[1] as StringTableField;
  StringTableField get country => _properties[2] as StringTableField;
}
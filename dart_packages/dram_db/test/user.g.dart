/* THIS WILL BE A GENERATED FILE */
part of 'database.g.dart';

class UsersTable extends DatabaseTable<User> {

  UsersTable._() : super('users', AppDatabase._instance);
  static final UsersTable _instance = UsersTable._();

  static final List<Queryable> _properties = [
    StringTableField('id'),
    StringTableField('name'),
    StringTableField('lastName'),
    IntTableField('age'),
    DoubleTableField('points'),
    ListTableField<Address>('addresses'),
    PhoneNumberModel._instance
  ];

  StringTableField get id => _properties[0] as StringTableField;
  StringTableField get name => _properties[1] as StringTableField;
  StringTableField get lastName => _properties[2] as StringTableField;
  IntTableField get age => _properties[3] as IntTableField;
  DoubleTableField get points => _properties[4] as DoubleTableField;
  ListTableField<Address> get addresses => _properties[5] as ListTableField<Address>;
  PhoneNumberModel get phoneNumber => _properties[6] as PhoneNumberModel;

  @override
  User fromTable(Map<String, Object> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      surname: map['lastName'] as String,
      age: map['age'] as int,
      points: map['points'] as double,
      phoneNumber: PhoneNumberModel._instance.fromTable(map['phoneNumber'] as Map<String, Object>),
      addresses: (map['addresses'] as List).map((e) => AddressModel._instance.fromTable(e)).toList(),
      isEnabled: false
    );
  }

  @override
  Map<String, Object> toTable(User model) {
    return {
      'id': model.id,
      'name': model.name,
      'lastName': model.surname,
      'age': model.age,
      'points': model.points,
      'addresses': model.addresses.map((e) => AddressModel._instance.toTable(e)),
      'phoneNumber': PhoneNumberModel._instance.toTable(model.phoneNumber)
    };
  }
}

class AddressModel extends DatabaseModel<Address> {
  static final AddressModel _instance = AddressModel._();
  AddressModel._() : super('addresses');

  static final List<Queryable> _properties = [
    StringTableField('street'),
    IntTableField('streetNumber'),
    CoordinatesModel._instance
  ];

  StringTableField get street => _properties[0] as StringTableField;
  IntTableField get streetNumber => _properties[1] as IntTableField;
  CoordinatesModel get coordinates => _properties[2] as CoordinatesModel;

  @override
  Address fromTable(Map<String, Object> map) {
    return Address(
      street: map['street'] as String,
      streetNumber: map['streetNumber'] as int,
      coordinates: CoordinatesModel._instance.fromTable(map['coordinates'] as Map<String, Object>)
    );
  }

  @override
  Map<String, Object> toTable(Address model) {
    return {
      'street': model.street,
      'streetNumber': model.streetNumber,
      'coordinates': CoordinatesModel._instance.toTable(model.coordinates)
    };
  }
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

  @override
  Coordinates fromTable(Map<String, Object> map) {
    return Coordinates(latitude: map['latitude'] as double, longitude: map['longitude'] as double);
  }

  @override
  Map<String, Object> toTable(Coordinates model) {
    return {
      'latitude': model.latitude,
      'longitude': model.longitude
    };
  }
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

  @override
  PhoneNumber fromTable(Map<String, Object> map) {
    return PhoneNumber(
      prefix: map['prefix'] as String, 
      number: map['number'] as String, 
      country: map['country'] as String
    );
  }

  @override
  Map<String, Object> toTable(PhoneNumber model) {
    return {
      'prefix': model.prefix,
      'number': model.number,
      'country': model.country
    };
  }
}
import 'package:drambase/drambase.dart';
import 'package:drambase/src/annotations/table.dart';

@table(name: 'users')
class User {
  
  @primaryKey()
  final String id;
  final String name;
  @index()
  final String surname;
  @index()
  @tableField(name: 'userAge')
  final int age;
  final double points;
  final List<Address> addresses;
  final PhoneNumber phoneNumber;
  
  @notMapped()
  final bool isEnabled;

  User({required this.id, required this.name, required this.surname, required this.age, required this.points, required this.addresses, required this.phoneNumber, required this.isEnabled});
}

class Address {
  final String street;
  final int streetNumber;
  final Coordinates coordinates;

  Address({required this.street, required this.streetNumber, required this.coordinates});
}

// This class is added to the model implicitily because it depends on Address, which is maked as
// Model but also depends from User, which is a marked as Model.
class Coordinates {
  final double latitude, longitude;
  Coordinates({required this.latitude, required this.longitude});
}

class PhoneNumber {
  final String prefix;
  final String number;

  @index()
  final String country;

  PhoneNumber({required this.prefix, required this.number, required this.country});
}
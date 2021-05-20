import 'package:dram/src/exception/base_exception.dart';

class ObjectNotImplementsComparable extends BaseException {
  ObjectNotImplementsComparable(String objectType) : super(message: "The object type '$objectType' does not implement Comparable and cannot be used while ordering.");

}
import 'package:reflectable/reflectable.dart';

class Reflection extends Reflectable {
  const Reflection() : super(invokingCapability, reflectedTypeCapability, typeCapability, typeAnnotationDeepQuantifyCapability);
}

const reflection = Reflection();
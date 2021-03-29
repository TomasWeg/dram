import 'package:dram/src/exception/base_exception.dart';

class ServiceNotRegisteredException extends BaseException {
  final String serviceType;

  ServiceNotRegisteredException({required this.serviceType}) : super(message: 'The service "$serviceType" is not registered.');
}
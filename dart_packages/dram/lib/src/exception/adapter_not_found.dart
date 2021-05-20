import 'package:dram/src/exception/base_exception.dart';

class AdapterNotFoundException extends BaseException {
  const AdapterNotFoundException(Type modelType, [Type? serviceType]) :
   super(message: serviceType == null ? "Adapter for type '$modelType' not found." : "Adapter for type $modelType for service $serviceType not found.");
}
import 'package:dram/src/exception/base_exception.dart';

class AdapterNotFoundException extends BaseException {
  const AdapterNotFoundException(Type modelType) : super(message: "Adapter for type '$modelType' not found.");
}
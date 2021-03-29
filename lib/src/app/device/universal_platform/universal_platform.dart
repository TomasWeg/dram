import 'package:dram/src/app/device/platform.dart';
import 'platform_web.dart' 
  if(dart.library.io) 'platform_io.dart';

class UniversalPlatform {
  UniversalPlatform._();

  static Platform getCurrentPlatform() {
    return currentUniversalPlatform;
  }
}
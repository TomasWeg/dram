import 'package:dram/src/app/device/platform.dart';
import 'dart:io' as io;

Platform get currentUniversalPlatform {
  if(io.Platform.isWindows) return Platform.Windows;
  if(io.Platform.isMacOS) return Platform.MacOS;
  if(io.Platform.isLinux) return Platform.Linux;
  if(io.Platform.isIOS) return Platform.IOS;
  return Platform.Android;
}
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dram/src/app/device/platform.dart';
import 'package:dram/src/app/device/universal_platform/universal_platform.dart';
import 'package:system_info/system_info.dart';

/// Contains information about the current device where the application
/// is running on
class DeviceInformation {

  static DeviceInformation? _current;

  Platform _platform;
  String _name, _version;
  String? _manufacturer;
  String? _model;

  /// The current platform
  Platform get platform => this._platform;

  /// The name of the device
  String get name => this._name;

  /// The current version of the device
  String get version => this._version;

  /// The manufacturer of the current device
  String? get manufacturer => this._manufacturer;

  /// The device model
  String? get model => this._model;

  DeviceInformation._(this._platform, this._name, this._version, this._manufacturer, this._model);

  static Future<DeviceInformation> getCurrentDeviceInformation() async {
    if(_current == null) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      Platform platform = UniversalPlatform.getCurrentPlatform();

      switch(platform) {
        case Platform.Android:
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          _current = DeviceInformation._(platform, androidInfo.device ?? "unknown", androidInfo.version.toString(), androidInfo.manufacturer, androidInfo.model);
          break;

        case Platform.IOS:
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          _current = DeviceInformation._(platform, iosInfo.name!, iosInfo.systemVersion ?? "unknown", "Apple", iosInfo.model);
          break;

        case Platform.Linux:
          LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
          _current = DeviceInformation._(platform, linuxInfo.name, linuxInfo.version ?? "unknown", null, linuxInfo.variant);
          break;

        case Platform.MacOS:
          MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
          _current = DeviceInformation._(platform, macOsInfo.hostName, macOsInfo.kernelVersion, "Apple", macOsInfo.model);
          break;

        case Platform.Windows:
          _current = DeviceInformation._(platform, "Windows", SysInfo.operatingSystemVersion, "Microsoft", null);
          break;

        case Platform.Web:
          WebBrowserInfo browserInfo = await deviceInfo.webBrowserInfo;
          _current = DeviceInformation._(platform, browserInfo.browserName.toString(), browserInfo.appVersion, "${browserInfo.vendor} ${browserInfo.vendorSub}", browserInfo.platform);
          break;

        default:
          throw new Exception("Unsupported platform: $platform"); 
      }
    }

    return _current!;
  }

  Map<String, dynamic> toJson() {
    return {
      "platform": this._platform.toString(),
      "name": this._name,
      "version": this._version,
      "manufacturer": this._manufacturer,
      "model": this._model
    };
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer("[$platform] $name $version");
    if(manufacturer != null) {
      buffer.write(" - $manufacturer");
    }

    if(model != null) {
      buffer.write(model);
    }

    return buffer.toString();
  }
}
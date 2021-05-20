import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;
import 'package:universal_html/html.dart' as html;
import 'package:dram/app.dart';
import 'package:dram/logger.dart';
import 'package:dram/module.dart';
import 'package:dram/src/app/device/universal_platform/universal_platform.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class StorageModule extends Module {

  static const String _entriesFileName = "preferences";

  final Map<DirectoryInfo, Directory> _directories;
  final StorageOptions _options;
  final Map<String, Object> _entries; // Entries that are saved as key-value pairs
  
  late StoragePreferences _storagePreferences;
  late StorageSecured _storageSecured;

  /// Access to preferences of the application
  StoragePreferences get preferences => _storagePreferences;

  /// Access to encrypted preferences of the application
  StorageSecured get secured => _storageSecured;

  /// Initializes the [StorageModule].
  StorageModule({StorageOptions? options}) : _options = options ?? StorageOptions(), _directories = {}, _entries = {} {
    _storagePreferences = StoragePreferences._internal(this);
    _storageSecured = StorageSecured._internal();
  }
  
  @override
  Future initialize() async {
    Platform currentPlatform = UniversalPlatform.getCurrentPlatform();
    List<DirectoryInfo>? directories;
    if(_options.platformPathBuilder != null) {
      directories = _options.platformPathBuilder!(currentPlatform);
    }

    if(directories == null || directories.isEmpty) {
      directories = directories ?? <DirectoryInfo>[DirectoryInfo.platformDefault];
    }

    if(directories.contains(DirectoryInfo.platformDefault)) {
      directories.clear();
      directories.addAll(_getPlatformDefaults(currentPlatform));
    }

    for(DirectoryInfo dirInfo in directories) {
      Directory directory = await _getDirectory(currentPlatform, dirInfo);
      _directories[dirInfo] = directory;
    }

    Logger.info("Loaded ${_directories.length} directories.");

    // Load preferences
    await _loadKeyValuePairEntries();
  }

  /// Returns a reference to a file
  File getFile(DirectoryInfo directoryInfo, String relativePath) {
    Directory? dir = _directories[directoryInfo];
    if(dir == null) {
      throw new Exception("Directory info $directoryInfo not found.");
    }

    return File(path.join(dir.path, relativePath));
  }

  /// Creates a file and returns a reference
  Future<File> createFile(DirectoryInfo directoryInfo, String relativePath) async {
    File file = getFile(directoryInfo, relativePath);
    if(!await file.exists()) {
      await file.create(recursive: true);
    }

    return file;
  }

  /// Returns a reference to a directory
  Directory getDirectory(DirectoryInfo directoryInfo, String relativePath) {
    Directory? dir = _directories[directoryInfo];
    if(dir == null) {
      throw new Exception("Directory info $directoryInfo not found.");
    }

    return Directory(path.join(dir.path, relativePath));
  }

  /// Creates a directory and returns a reference
  Future<Directory> createDirectory(DirectoryInfo directoryInfo, String relativePath) async {
    Directory directory = getDirectory(directoryInfo, relativePath);
    if(!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  Future _loadKeyValuePairEntries() async {
    String? jsonEncodedEntries;

    if(kIsWeb) {
      jsonEncodedEntries = html.window.localStorage[_entriesFileName];
    } else {
      Directory? directory = _directories[DirectoryInfo.documents];
      assert(directory == null, "Directory at ${DirectoryInfo.documents} not found.");

      String filePath = path.join(directory!.path, "$_entriesFileName${_options.preferencesFileFormat.getExtension()}");
      File preferencesFile = File(filePath);
      if(await preferencesFile.exists()) {

        // Read file
        Uint8List fileContent = await preferencesFile.readAsBytes();
        jsonEncodedEntries = utf8.decode(fileContent);
      } 
    }

    if(jsonEncodedEntries != null) {
      // Decode json
      var jsonDecoded = (json.decode(jsonEncodedEntries) as Map<dynamic, dynamic>).cast<String, Object>();
    
      // Add entries
      this._entries.addAll(jsonDecoded);

      Logger.debug("${this._entries.length} entries were read.");
    } else {
      Logger.error("Could not load any entry because input was null.");
    }
  }

  Future _saveKeyValuePairEntries() async {
    String jsonEncoded = json.encode(this._entries);
    
    if(kIsWeb) {
      html.window.localStorage[_entriesFileName] = jsonEncoded;
      Logger.debug("${this._entries.length} entries were saved to localStorage.");
    } else {
      Directory? directory = _directories[DirectoryInfo.documents];
      assert(directory == null, "Directory at ${DirectoryInfo.documents} not found.");

      String filePath = path.join(directory!.path, "$_entriesFileName${_options.preferencesFileFormat.getExtension()}");
      File preferencesFile = File(filePath);
      if(!await preferencesFile.exists()) {
        await preferencesFile.create(recursive: true);
      }  

      if(_options.preferencesFileFormat == FileFormat.json) {
        await preferencesFile.writeAsString(jsonEncoded, encoding: utf8, mode: FileMode.write);
      } else if(_options.preferencesFileFormat == FileFormat.binary) {
        Uint8List buffer = Uint8List.fromList(utf8.encode(jsonEncoded));
        await preferencesFile.writeAsBytes(buffer);
      }

      Logger.debug("${this._entries.length} entries were saved to $filePath using ${_options.preferencesFileFormat} format.");
    }
  }

  List<DirectoryInfo> _getPlatformDefaults(Platform platform) {
    switch(platform) {
      case Platform.IOS:
        return [DirectoryInfo.app, DirectoryInfo.documents, DirectoryInfo.temporary];

      case Platform.Windows:
      case Platform.Linux:
      case Platform.MacOS:
      case Platform.Android:
        return [DirectoryInfo.app, DirectoryInfo.documents, DirectoryInfo.temporary, DirectoryInfo.appData, DirectoryInfo.external];

      case Platform.Web:
        return [];
    }
  }

  Future<Directory> _getDirectory(Platform platform, DirectoryInfo dirInfo) async {
    switch(dirInfo) {
      case DirectoryInfo.temporary:
        return await pathProvider.getTemporaryDirectory();

      case DirectoryInfo.documents:
        return await pathProvider.getApplicationDocumentsDirectory();

      case DirectoryInfo.app:
        return Directory.current;

      case DirectoryInfo.appData:
        return await pathProvider.getApplicationSupportDirectory();

      case DirectoryInfo.external:
        Directory? dir = await pathProvider.getExternalStorageDirectory();
        if(dir == null) {
          throw new UnsupportedError("The platform $platform does not support DirectoryInfo.external.");
        }

        return dir;

      default:
        throw new UnsupportedError("The platform $platform does not support $dirInfo.");
    }
  }
}

/// Options to configure a [StorageModule]
class StorageOptions {

  final bool cacheEnabled;
  final List<DirectoryInfo>? Function(Platform)? platformPathBuilder;
  final FileFormat preferencesFileFormat;

  /// [cacheEnabled] indicates if the cache folder will be used. Defaults to true.
  /// [platformPathBuilder] is used to create different folder paths dependending the current running platform
  StorageOptions({this.cacheEnabled = true, this.platformPathBuilder, this.preferencesFileFormat = FileFormat.binary});

}

class StoragePreferences {
  final StorageModule _storageModule;
  StoragePreferences._internal(this._storageModule);

  Future setString(String key, String value) {
    _storageModule._entries[key] = value;
    _storageModule._saveKeyValuePairEntries();
    return Future.value();
  }

  Future setBoolean(String key, bool value) {
    _storageModule._entries[key] = value;
    _storageModule._saveKeyValuePairEntries();
    return Future.value();
  }

  Future setDouble(String key, double value) {
    _storageModule._entries[key] = value;
    _storageModule._saveKeyValuePairEntries();
    return Future.value();
  }

  Future setInt(String key, int value) {
    _storageModule._entries[key] = value;
    _storageModule._saveKeyValuePairEntries();
    return Future.value();
  }

  Future setMap(String key, Map<String, dynamic> value) {
    _storageModule._entries[key] = value;
    _storageModule._saveKeyValuePairEntries();
    return Future.value();
  }

  Future setList(String key, List value) {
    _storageModule._entries[key] = value;
    _storageModule._saveKeyValuePairEntries();
    return Future.value();
  }

  Future clear() {
    _storageModule._entries.clear();
    _storageModule._saveKeyValuePairEntries();
    return Future.value();
  }

  int? readInt(String key) => _storageModule._entries[key] as int?;
  bool? readBool(String key) => _storageModule._entries[key] as bool?;
  double? readDouble(String key) => _storageModule._entries[key] as double?;
  String? readString(String key) => _storageModule._entries[key] as String?;
  Object? read(String key) => _storageModule._entries[key];
  Set<String> keys() => Set<String>.from(_storageModule._entries.keys);
  bool exists(String key) => _storageModule._entries.containsKey(key);
}

class StorageSecured {
  late FlutterSecureStorage _securedStorage;

  StorageSecured._internal() {
    _securedStorage = FlutterSecureStorage();
  }

  Future store(String key, String value) {
    return _securedStorage.write(
      key: key, 
      value: value,
    );
  }

  Future<String?> read(String key) {
    return _securedStorage.read(key: key);  
  }

  Future clear() {
    return _securedStorage.deleteAll();
  }
}

enum FileFormat {
  binary,
  json
}

enum DirectoryInfo {
  /// The documents directory
  documents,

  /// External files of the app
  external,

  /// The directory to store temporary data
  temporary,

  /// Directory to store app data
  appData,

  /// The folder where the app is
  app,

  /// Uses the platform default folders
  platformDefault
}

extension _FileFormatExtension on FileFormat {
  static const Map<FileFormat, String> _extensions = {
    FileFormat.binary: ".bin",
    FileFormat.json: ".json"
  };

  String getExtension() {
    return _extensions[this]!;
  }
}
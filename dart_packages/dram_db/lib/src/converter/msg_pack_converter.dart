import 'dart:typed_data';

import 'package:drambase/src/converter/converter.dart';
import 'package:messagepack/messagepack.dart';

class MessagePackConverter extends Converter {

  Packer? _packer;
  Unpacker? _unpacker;

  @override
  Map<String, Object?> decode(Uint8List buffer) {
    if(_unpacker != null) {
      _unpacker = null;
    }

    _unpacker = Unpacker(buffer);
    var values = _unpacker!.unpackMap();
    return _decodeMap(values);
  }

  @override
  Uint8List encode(Map<String, Object?> type) {
    if(_packer != null) {
      _packer = null;
    }

    _packer = Packer();
    _packer!.packMapLength(type.length);
    for(var entry in type.entries) {
      _packType(entry.key, entry.value);
    }

    return _packer!.takeBytes();
  }

  Map<String, Object?> _decodeMap(Map<Object?, Object?> map) {
    var result = <String, Object?>{};

    for(var entry in map.entries) {
      var key = entry.key as String;
      var value = entry.value;
      
      if(value is Map) {
        var mapResult = _decodeMap(value);
        result[key] = mapResult;        
      } else {
        // decode date
        if(value is String && value.startsWith(':d:')) {
          value = DateTime.fromMillisecondsSinceEpoch(int.parse(value.replaceAll(':d:', '')));
        }

        result[key] = value;
      }
    }

    return result;
  }

  void _packType(String key, Object? value) {
    // _packer!.packMapLength(1);
    _packer!.packString(key);
    _packValue(value);
  }

  void _packValue(Object? value) {
    if(value is String?) {
      _packer!.packString(value == null ? null : (value.isEmpty ? null : value));
    } else if(value is double) {
      _packer!.packDouble(value);
    } else if(value is int) {
      _packer!.packInt(value);
    } else if(value is bool) {
      _packer!.packBool(value);
    } else if(value is List) {
      _packer!.packListLength(value.length);
      for(var listEntry in value) {
        _packValue(listEntry);
      }
    } else if(value is Map) {
      _packer!.packMapLength(value.length);
      for(var mapEntry in value.entries) {
        _packType(mapEntry.key, mapEntry.value);
      }
    } else if(value is DateTime) {
      _packer!.packString(':d:${value.millisecondsSinceEpoch}');
    } else {
      throw ArgumentError('Cannot convert ${value.runtimeType} type.');
    }
  }

}
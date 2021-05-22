import 'dart:typed_data';

import 'package:messagepack/messagepack.dart';

abstract class Mapper<T> {
  void encode(T value, DynamicBuffer buffer);
}

class DynamicBuffer {

  factory DynamicBuffer.instance() {
    return DynamicBuffer._();
  }

  Packer? _packer;
  final List<_DynamicBufferWrite> _operations;
  DynamicBuffer._() : this._operations = [] {
    this._packer = Packer();
  }

  DynamicBuffer writeInt(String field, int? value) {
    _checkPacker();
    _operations.add(_DynamicBufferWrite(_DynamicBufferWriteOperation.int, field, value));
    return this;
  }

  DynamicBuffer writeDouble(String field, double? value) {
    _checkPacker();
    _operations.add(_DynamicBufferWrite(_DynamicBufferWriteOperation.double, field, value));
    return this;
  }

  DynamicBuffer writeBool(String field, bool? value) {
    _checkPacker();
    _operations.add(_DynamicBufferWrite(_DynamicBufferWriteOperation.bool, field, value));
    return this;
  }

  DynamicBuffer writeString(String field, String? value) {
    _checkPacker();
    _operations.add(_DynamicBufferWrite(_DynamicBufferWriteOperation.string, field, value));
    return this;
  }

  DynamicBuffer writeList<T>(String field, List<T> value) {
    _checkPacker();
    _operations.add(_DynamicBufferWrite(_DynamicBufferWriteOperation.list, field, value));

    return this;
  }

  DynamicBuffer writeMap(String field, Map<String, dynamic> value) {
    _checkPacker();
    _operations.add(_DynamicBufferWrite(_DynamicBufferWriteOperation.map, field, value));

    return this;
  }

  DynamicBuffer writeDateTime(String field, DateTime value) {
    _checkPacker();
    _operations.add(_DynamicBufferWrite(_DynamicBufferWriteOperation.datetime, field, value));
    return this;
  }

  void _packEntry<T>(String key, T? value) {
    // _packer!.packMapLength(1);
    _packer!.packString(key);
    _write(value);
  }

  void _write(dynamic value) {
    _checkPacker();
    if(value is bool?) {
      _packer!.packBool(value);
      print("Packed bool");
    } else if(value is int?) {
      _packer!.packInt(value);
      print("Packed int");
    } else if(value is double?) {
      _packer!.packDouble(value);
      print("Packed double");
    } else if(value is String?) {
      _packer!.packString(value != null ? (value.isEmpty ? null : value) : null);
      print("Packed string");
    } else if(value is List){
      _packer!.packListLength(value.length);
      for(var entry in value) {
        _write(entry);
      }
      print("Packed list");
    } else if(value is Map) {
      _packer!.packMapLength(value.length);
      value.forEach((k, v) {
        _write(k);
        _write(v);  
      });
      print("Packed map");
    } else if(value is DateTime) {
      _packer!.packMapLength(1);
      _packer!.packString("_d_");
      _packer!.packInt(value.millisecondsSinceEpoch);
      print("Packed datetime");
    } else {
      throw new Exception("Cannot encode $value");
    }
  }

  void _checkPacker() {
    if(_packer == null) {
      throw new Exception("DynamicBuffer is closed.");
    }
  }

  Uint8List close() {

    // Ensure size
    _packer!.packMapLength(this._operations.length);

    // pack each entry
    for(_DynamicBufferWrite operation in this._operations) {
      switch(operation.operation) {
        case _DynamicBufferWriteOperation.bool:
          _packEntry<bool>(operation.field, operation.value);
          break;

        case _DynamicBufferWriteOperation.int:
          _packEntry<int>(operation.field, operation.value);
          break;

        case _DynamicBufferWriteOperation.double:
          _packEntry<double>(operation.field, operation.value);
          break;

        case _DynamicBufferWriteOperation.string:
          _packEntry<String>(operation.field, operation.value);
          break;

        case _DynamicBufferWriteOperation.list:
          _packEntry<List>(operation.field, operation.value);
          break;

        case _DynamicBufferWriteOperation.map:
          _packEntry<Map>(operation.field, operation.value);
          break;

        case _DynamicBufferWriteOperation.datetime:
          _packEntry<DateTime>(operation.field, operation.value);
          break;
      }
    }

    // Compile and return buffer
    Uint8List buffer = _packer!.takeBytes();
    this._packer = null;
    return buffer;
  }
}

class _DynamicBufferWrite {
  final _DynamicBufferWriteOperation operation;
  final String field;
  final dynamic value;

  _DynamicBufferWrite(this.operation, this.field, this.value);
}

enum _DynamicBufferWriteOperation {
  int, double, string, bool, map, list, datetime
}
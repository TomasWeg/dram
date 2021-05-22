import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

typedef open_database_func = Uint8 Function(Pointer<Utf8> buff);
typedef OpenDatabase = int Function(Pointer<Utf8> buff);

typedef close_database_func = Uint8 Function();
typedef CloseDatabase = int Function();

typedef create_table_func = Uint8 Function(Pointer<Utf8> tableName);
typedef CreateTable = int Function(Pointer<Utf8> tableName);

typedef insert_func = Uint8 Function(Pointer<Utf8> tableName, Pointer<Uint8> buffer, Int32 bufferLength);
typedef Insert = int Function(Pointer<Utf8> tableName, Pointer<Uint8> buffer, int bufferLength);

typedef update_func = Uint8 Function(Pointer<Utf8> tableName, Pointer<Utf8> entityId, Pointer<Uint8> buffer, Int32 bufferLength);
typedef Update = int Function(Pointer<Utf8> tableName, Pointer<Utf8> entityId, Pointer<Uint8> buffer, int bufferLength);

typedef create_index_func = Uint8 Function(Pointer<Utf8> indexName, Pointer<Utf8> tableName, Pointer<Utf8> fieldName, Pointer<Uint8> isUnique);
typedef CreateIndex = int Function(Pointer<Utf8> indexName, Pointer<Utf8> tableName, Pointer<Utf8> fieldName, Pointer<Uint8> isUnique);

final lib = DynamicLibrary.open(path.join(Directory.current.path, "lib.a"));
final openDatabaseFunc = lib.lookupFunction<open_database_func, OpenDatabase>("OpenDatabase");
final closeDatabaseFunc = lib.lookupFunction<close_database_func, CloseDatabase>("Close");
final insertFunc = lib.lookupFunction<insert_func, Insert>("Insert");
final updateFunc = lib.lookupFunction<update_func, Update>("Update");
final createTableFunc = lib.lookupFunction<create_table_func, CreateTable>("CreateTable");
final createIndexFunc = lib.lookupFunction<create_index_func, CreateIndex>("CreateIndex");

void openDatabase(String path, Uint8List? writeBuffer) {
  openDatabaseFunc(path.toNativeUtf8());
  // createIndexFunc("idx_age".toNativeUtf8(), "test".toNativeUtf8(), "age".toNativeUtf8(), malloc.allocate<Uint8>(sizeOf<Uint8>())..value = 1);
  
}

void testInsert(Uint8List buffer) {
  var bufferPtr = malloc.allocate<Uint8>(buffer.length);
  var out = bufferPtr.asTypedList(buffer.length);
  out.setAll(0, buffer);

  int result = createTableFunc("test".toNativeUtf8());
  print("Create table result: ${!(result == 0x58)}");
  
  insertFunc("test".toNativeUtf8(), bufferPtr, buffer.length);

  malloc.free(bufferPtr);
}

void testUpdate(String tableName, String id, Uint8List buffer) {
  var bufferPtr = malloc.allocate<Uint8>(buffer.length);
  var out = bufferPtr.asTypedList(buffer.length);
  out.setAll(0, buffer);

  updateFunc(tableName.toNativeUtf8(), id.toNativeUtf8(), bufferPtr, buffer.length);
  malloc.free(bufferPtr);
}

import 'dart:typed_data';

import 'package:dram_db_bindings/dram_db_ffi.dart';
import 'package:dram_db_bindings/mapper.dart';
import 'package:test/test.dart';

void main() {
  
  test("Test openDatabase", () {

    Example example = Example(
      id: "123",
      name: "Tomas", 
      age: 23, 
      points: 25487.2542, 
      enabled: true, 
      // surnames: ["Lopez", "Weigenast"]
    );

    DynamicBuffer buffer = DynamicBuffer.instance();
    ExampleMapper().encode(example, buffer);

    Uint8List data = buffer.close();

    openDatabase("database.db", data);
    testUpdate("test", "123", data);
  });

}

class Example {
  final String? id;
  final String name;
  final int age;
  final double points;
  final bool enabled;
  final List<String>? surnames;

  Example({this.id, required this.name, required this.age, required this.points, required this.enabled, this.surnames});
}

class ExampleMapper extends Mapper<Example> {
  @override
  void encode(Example value, DynamicBuffer buffer) {
    buffer
      .writeString("id", value.id)
      .writeString("name", value.name)
      .writeInt("age", value.age)
      .writeDouble("points", value.points)
      .writeBool("enabled", value.enabled);
      // .writeList("surnames", value.surnames);
  }

}
import 'package:meta/meta_meta.dart';

/// Annotation that must be added to any class that wants to be mapped to a dram database
@Target({TargetKind.classType})
class table {

  final String? name;

  /// Annotation that must be added to any class that wants to be mapped to a dram database
  const table({this.name});
}
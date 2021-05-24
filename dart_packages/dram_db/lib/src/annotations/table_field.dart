import 'package:meta/meta_meta.dart';

/// Annotation that can be attached to a property to modify its name while mapping
@Target({TargetKind.field})
class TableField {
  final String? name;

  /// Annotation that can be attached to a property to modify its name while mapping
  const TableField({this.name});
}
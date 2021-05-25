import 'package:meta/meta_meta.dart';

/// Annotation that can be attached to a property to modify its name while mapping
@Target({TargetKind.field})
class tableField {
  final String name;

  /// Annotation that can be attached to a property to modify its name while mapping
  const tableField({required this.name});
}

/// Represents the primary key of an entry
@Target({TargetKind.field})
class primaryKey {
  
  /// Represents the primary key of an entry
  const primaryKey();
}

/// Represents an index on a field
@Target({TargetKind.field})
class index {

  /// Represents an index on a field
  const index();
}

/// Indicates a field to not be mapped
@Target({TargetKind.field})
class notMapped {

  /// Indicates a field to not be mapped
  const notMapped();
}
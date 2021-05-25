import 'package:drambase/src/database/table.dart';
import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class Drambase {
  final List<dynamic> models;

  const Drambase({required this.models});
}
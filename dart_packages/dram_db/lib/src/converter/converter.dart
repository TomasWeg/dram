import 'dart:typed_data';

/// Represents a basic encoder/decoder
abstract class Converter {
  
  /// Encodes a type
  Uint8List encode(Map<String, Object?> type);

  /// Decodes a type
  Map<String, Object?> decode(Uint8List buffer);
}
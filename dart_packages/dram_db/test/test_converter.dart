

import 'package:drambase/src/converter/msg_pack_converter.dart';
import 'package:test/test.dart';

void main() {
  group('Test value converters', () {
    test('MessagePack converter', () {

      var map = <String, Object?>{
        'age': 25,
        'name': 'Tomas',
        'points': 26.2542,
        'surnames': ['Johan', 'Mano'],
        'registeredDate': DateTime.now().subtract(Duration(days: 600)),
        'address': <String, Object?>{
          'street': '25 de Mayo',
          'streetNumber': 715,
          'country': 'Argentina',
          'date': DateTime.now().add(Duration(seconds: 60000))
        }
      };

      var converter = MessagePackConverter();
      var buffer = converter.encode(map);
      var decoded = converter.decode(buffer);
      print(decoded);
    });
  });
}
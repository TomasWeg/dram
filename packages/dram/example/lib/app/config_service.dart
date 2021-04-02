import 'package:dram/app.dart';

class ConfigService extends RequiredService {
  
  @override
  Future init() async {
    await Future.delayed(Duration(seconds: 5));
  }

}
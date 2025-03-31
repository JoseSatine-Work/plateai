import 'package:flutter/services.dart';

class CoreMlService {
  static const platform = MethodChannel('com.example.food101');

  static Future<dynamic> predictImage(String imagePath) async {
    try {
      final dynamic result = await platform.invokeMethod('predict', {
        'imagePath': imagePath,
      });

      print(result);

      return result;
    } on PlatformException catch (e) {
      print('Failed to predict image: ${e.message}');
      return null;
    }
  }
}

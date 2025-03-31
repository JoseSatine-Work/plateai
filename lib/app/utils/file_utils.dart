import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> saveImage(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().toIso8601String();
    final savedImage = await imageFile.copy('${appDir.path}/$fileName.png');
    return savedImage.path;
  }
}

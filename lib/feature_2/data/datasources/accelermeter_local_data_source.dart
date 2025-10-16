import 'dart:io';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@injectable
class AccelerometerLocalDataSource {
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/accelerometer_data.json');
  }

  Future<void> saveToFile(Map<String, dynamic> data) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>?> readFromFile() async {
    final file = await _getFile();
    if (!await file.exists()) return null;
    final contents = await file.readAsString();
    return jsonDecode(contents);
  }
}

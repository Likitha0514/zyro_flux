import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String _fileName = 'zyro_flux.json';

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/$_fileName');
  }

  Future<Map<String, dynamic>> readData() async {
    final file = await _getFile();

    if (!await file.exists()) {
      return {};
    }

    final content = await file.readAsString();

    if (content.isEmpty) {
      return {};
    }

    return jsonDecode(content) as Map<String, dynamic>;
  }

  Future<void> writeData(Map<String, dynamic> data) async {
    final file = await _getFile();

    await file.writeAsString(
      jsonEncode(data),
      flush: true,
    );
  }

  Future<void> clearData() async {
  final file = await _getFile();

  if (await file.exists()) {
    await file.delete();
  }
}
}
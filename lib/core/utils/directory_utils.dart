import 'dart:io';

import 'package:path/path.dart';

class DirectoryUtils {
  static void create(String path) {
    path = normalize(path);
    if (Directory(path).existsSync()) {
      return;
    }
    var complete = path.split('\\')[0];
    final exist = Directory(complete).existsSync();
    if (!exist) Directory(complete).createSync();
    
    for (var i = 1; i < path.split('\\').length; i++) {
      final e = path.split('\\')[i];
      if (e.isEmpty) continue;

      complete += '/$e';
      final exist = Directory(complete).existsSync();
      if (!exist) Directory(complete).createSync();
    }
  }
}

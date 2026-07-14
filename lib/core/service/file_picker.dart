import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';

abstract class FilePickerService {
  static Future<File?> pickFile(List<String> extensions) async {
    try {
      XTypeGroup typeGroup = XTypeGroup(
        label: 'All Documents',
        extensions: extensions,
      );

      final XFile? result = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );

      if (result != null) {
        return File(result.path);
      }
    } catch (e) {
      // Caught gracefully; UI handles errors through state mutations
      debugPrint("Pick error -> e");
    }
    return null;
  }

  static Future<List<File>?> pickMultiFile(List<String> extensions) async {
    try {
      XTypeGroup typeGroup = XTypeGroup(
        label: 'All Documents',
        extensions: extensions,
      );

      // 1. Use openFiles (plural) instead of openFile
      final List<XFile> result = await openFiles(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );

      // 2. Check if the list is not null and not empty
      if (result.isNotEmpty) {
        // 3. Map the list of XFile to a list of File
        return result.map((xFile) => File(xFile.path)).toList();
      }
    } catch (e) {
      // Corrected the debugPrint to actually print the error object
      debugPrint("Pick error -> $e");
    }
    return null;
  }
}

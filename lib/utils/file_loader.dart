import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'constants.dart';

class FileContent {
  final String filename;
  final String content;
  final String extension;
  final int sizeBytes;

  FileContent({
    required this.filename,
    required this.content,
    required this.extension,
    required this.sizeBytes,
  });
}

class FileLoader {
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB

  static Future<FileContent?> pickAndLoadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          ...AppConstants.supportedTextFiles.map((e) => e.substring(1)),
          ...AppConstants.supportedCodeFiles.map((e) => e.substring(1)),
        ],
      );

      if (result?.files.single.path != null) {
        return await loadFile(result!.files.single.path!);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<FileContent?> loadFile(String filePath) async {
    try {
      final file = File(filePath);
      final stats = await file.stat();
      
      if (stats.size > maxFileSizeBytes) {
        throw Exception('File too large (max 10MB)');
      }

      final content = await file.readAsString(encoding: utf8);
      final filename = filePath.split('/').last;
      final extension = '.${filename.split('.').last}';

      return FileContent(
        filename: filename,
        content: content,
        extension: extension,
        sizeBytes: stats.size,
      );
    } catch (e) {
      return null;
    }
  }

  static bool isSupportedFile(String filename) {
    final extension = '.${filename.split('.').last.toLowerCase()}';
    return AppConstants.supportedTextFiles.contains(extension) ||
           AppConstants.supportedCodeFiles.contains(extension);
  }

  static String getFileType(String extension) {
    if (AppConstants.supportedCodeFiles.contains(extension)) {
      return 'Code';
    } else if (AppConstants.supportedTextFiles.contains(extension)) {
      return 'Text';
    }
    return 'Unknown';
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
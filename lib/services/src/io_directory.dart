import 'dart:io';

List<String> listModelFilesInDir(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) return [];
  final files = dir
      .listSync(recursive: false)
      .where((f) => f is File && (f.path.endsWith('.gguf') || f.path.endsWith('.bin') || f.path.endsWith('.pt')))
      .map((f) => f.path)
      .toList();
  return files;
}

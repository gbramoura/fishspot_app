import 'dart:io';

class HttpMultipartFile {
  final File file;
  final String path;

  HttpMultipartFile({
    required this.file,
    required this.path,
  });
}

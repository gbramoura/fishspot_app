import 'dart:io';

import 'package:uuid/uuid.dart';

class SpotImage {
  final Uuid id;
  final File file;

  SpotImage({required this.id, required this.file});
}

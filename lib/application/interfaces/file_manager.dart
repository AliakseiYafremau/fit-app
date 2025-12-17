import 'dart:typed_data';

import 'package:fit_app/domain/entities/id.dart';

abstract class FileManager {
  Id store({
    required Uint8List bytes,
    String? fileName,
  });

  void update({
    required Id fileId,
    required Uint8List bytes,
  });

  Uint8List read(Id fileId);

  void delete(Id fileId);

  bool exists(Id fileId);
}

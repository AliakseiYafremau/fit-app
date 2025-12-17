import 'dart:io';
import 'dart:typed_data';

import 'package:fit_app/application/interfaces/file_manager.dart';
import 'package:fit_app/domain/entities/id.dart';

/// Simple file-system backed implementation for storing binary blobs.
class LocalFileManager implements FileManager {
  LocalFileManager({required Directory rootDirectory})
      : _rootDirectory = rootDirectory;

  final Directory _rootDirectory;
  Directory? _mediaDirectory;

  Directory get _storageDir {
    var dir = _mediaDirectory;
    if (dir != null) return dir;
    final mediaDir = Directory('${_rootDirectory.path}/media');
    if (!mediaDir.existsSync()) {
      mediaDir.createSync(recursive: true);
    }
    _mediaDirectory = mediaDir;
    return mediaDir;
  }

  File _resolveFile(Id fileId) => File('${_storageDir.path}/$fileId');

  @override
  Id store({required Uint8List bytes, String? fileName}) {
    final id = fileName ?? DateTime.now().microsecondsSinceEpoch.toString();
    final file = _resolveFile(id);
    file.writeAsBytesSync(bytes, flush: true);
    return id;
  }

  @override
  void update({required Id fileId, required Uint8List bytes}) {
    final file = _resolveFile(fileId);
    if (!file.existsSync()) {
      throw FileSystemException('File with id $fileId not found', file.path);
    }
    file.writeAsBytesSync(bytes, flush: true);
  }

  @override
  Uint8List read(Id fileId) {
    final file = _resolveFile(fileId);
    if (!file.existsSync()) {
      throw FileSystemException('File with id $fileId not found', file.path);
    }
    return file.readAsBytesSync();
  }

  @override
  void delete(Id fileId) {
    final file = _resolveFile(fileId);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  @override
  bool exists(Id fileId) => _resolveFile(fileId).existsSync();
}

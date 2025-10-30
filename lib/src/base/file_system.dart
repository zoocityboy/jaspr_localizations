// Copyright 2024 The Jaspr Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Abstract file system interfaces for Jaspr localization

import 'dart:io' as io;
import 'package:path/path.dart' as p;

abstract class JasprFileSystem {
  JasprFile file(String path);
  JasprDirectory directory(String path);
}

abstract class JasprFile extends JasprFileSystemEntity {
  String get basename;
  JasprDirectory get parent;
  String readAsStringSync();
  void writeAsStringSync(String contents);
  bool existsSync();
}

abstract class JasprDirectory extends JasprFileSystemEntity {
  List<JasprFileSystemEntity> listSync();
  JasprFile childFile(String name);
  bool existsSync();
  void createSync({bool recursive = false});
}

abstract class JasprFileSystemEntity {
  String get path;
}

// Concrete implementations
class LocalJasprFileSystem implements JasprFileSystem {
  const LocalJasprFileSystem();

  @override
  JasprFile file(String path) => LocalJasprFile(path);

  @override
  JasprDirectory directory(String path) => LocalJasprDirectory(path);
}

class LocalJasprFile implements JasprFile {
  LocalJasprFile(this.path) : _file = io.File(path);

  @override
  final String path;

  final io.File _file;

  @override
  String get basename => p.basename(path);

  @override
  JasprDirectory get parent => LocalJasprDirectory(p.dirname(path));

  @override
  String readAsStringSync() => _file.readAsStringSync();

  @override
  void writeAsStringSync(String contents) => _file.writeAsStringSync(contents);

  @override
  bool existsSync() => _file.existsSync();
}

class LocalJasprDirectory implements JasprDirectory {
  LocalJasprDirectory(this.path) : _directory = io.Directory(path);

  @override
  final String path;

  final io.Directory _directory;

  @override
  List<JasprFileSystemEntity> listSync() {
    return _directory.listSync().map((io.FileSystemEntity entity) {
      if (entity is io.File) {
        return LocalJasprFile(entity.path);
      } else if (entity is io.Directory) {
        return LocalJasprDirectory(entity.path);
      }
      throw UnsupportedError('Unsupported file system entity type');
    }).toList();
  }

  @override
  JasprFile childFile(String name) => LocalJasprFile(p.join(path, name));

  @override
  bool existsSync() => _directory.existsSync();

  @override
  void createSync({bool recursive = false}) => _directory.createSync(recursive: recursive);
}

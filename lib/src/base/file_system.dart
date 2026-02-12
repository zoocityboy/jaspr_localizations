// Copyright 2025 zoocityboy. All rights reserved.
// Use of this source code is governed by a MIT that can be
// found in the LICENSE file.

// Abstract file system interfaces for Jaspr localization

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

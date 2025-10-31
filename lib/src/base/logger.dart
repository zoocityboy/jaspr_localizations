// Copyright 2025 zoocityboy. All rights reserved.
// Use of this source code is governed by a MIT that can be
// found in the LICENSE file.

// Logger interface for Jaspr localization

abstract class Logger {
  void printError(String message);
  void printWarning(String message);
  void printStatus(String message);
}

class ConsoleLogger implements Logger {
  @override
  void printError(String message) {
    print('[ERROR] $message');
  }

  @override
  void printWarning(String message) {
    print('[WARNING] $message');
  }

  @override
  void printStatus(String message) {
    print('[INFO] $message');
  }
}

// Copyright 2024 The Jaspr Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Utilities for Jaspr localization based on Flutter's localizations_utils.dart

import 'package:meta/meta.dart';

import 'base/file_system.dart';

int sortFilesByPath(JasprFile a, JasprFile b) {
  return a.path.compareTo(b.path);
}

/// Simple data class to hold parsed locale. Does not promise validity of any data.
@immutable
class LocaleInfo implements Comparable<LocaleInfo> {
  const LocaleInfo({
    required this.languageCode,
    required this.scriptCode,
    required this.countryCode,
    required this.length,
    required this.originalString,
  });

  /// Simple parser. Expects the locale string to be in the form of 'language_script_COUNTRY'
  /// where the language is 2 characters, script is 4 characters with the first uppercase,
  /// and country is 2-3 characters and all uppercase.
  ///
  /// 'language_COUNTRY' or 'language_script' are also valid. Missing fields will be null.
  /// Also supports hyphen-separated format: 'language-COUNTRY'.
  ///
  /// When `deriveScriptCode` is true, if [scriptCode] was unspecified, it will
  /// be derived from the [languageCode] and [countryCode] if possible.
  factory LocaleInfo.fromString(String locale, {bool deriveScriptCode = false}) {
    // Normalize hyphens to underscores for parsing
    final String normalizedLocale = locale.replaceAll('-', '_');
    final List<String> codes = normalizedLocale.split('_'); // [language, script, country]
    assert(codes.isNotEmpty && codes.length < 4);
    final String languageCode = codes[0];
    String? scriptCode;
    String? countryCode;
    int length = codes.length;
    var originalString = locale;
    if (codes.length == 2) {
      scriptCode = codes[1].length >= 4 ? codes[1] : null;
      countryCode = codes[1].length < 4 ? codes[1] : null;
    } else if (codes.length == 3) {
      scriptCode = codes[1].length > codes[2].length ? codes[1] : codes[2];
      countryCode = codes[1].length < codes[2].length ? codes[1] : codes[2];
    }
    assert(codes[0].isNotEmpty);
    assert(countryCode == null || countryCode.isNotEmpty);
    assert(scriptCode == null || scriptCode.isNotEmpty);

    /// Adds scriptCodes to locales where we are able to assume it to provide
    /// finer granularity when resolving locales.
    ///
    /// The basis of the assumptions here are based off of known usage of scripts
    /// across various countries. For example, we know Taiwan uses traditional (Hant)
    /// script, so it is safe to apply (Hant) to Taiwanese languages.
    if (deriveScriptCode && scriptCode == null) {
      scriptCode = switch ((languageCode, countryCode)) {
        ('zh', 'CN' || 'SG' || null) => 'Hans',
        ('zh', 'TW' || 'HK' || 'MO') => 'Hant',
        ('sr', null) => 'Cyrl',
        _ => null,
      };
      // Increment length if we were able to assume a scriptCode.
      if (scriptCode != null) {
        length += 1;
      }
      // Update the base string to reflect assumed scriptCodes.
      originalString = languageCode;
      if (scriptCode != null) {
        originalString += '_$scriptCode';
      }
      if (countryCode != null) {
        originalString += '_$countryCode';
      }
    }

    return LocaleInfo(
      languageCode: languageCode,
      scriptCode: scriptCode,
      countryCode: countryCode,
      length: length,
      originalString: originalString,
    );
  }

  final String languageCode;
  final String? scriptCode;
  final String? countryCode;
  final int length; // The number of fields. Ranges from 1-3.
  final String originalString; // Original un-parsed locale string.

  String camelCase() {
    return originalString
        .split('_')
        .map<String>((String part) => part.substring(0, 1).toUpperCase() + part.substring(1).toLowerCase())
        .join();
  }

  @override
  bool operator ==(Object other) {
    return other is LocaleInfo && other.originalString == originalString;
  }

  @override
  int get hashCode => originalString.hashCode;

  @override
  String toString() {
    return originalString;
  }

  @override
  int compareTo(LocaleInfo other) {
    return originalString.compareTo(other.originalString);
  }
}

/// Return the input string as a Dart-parsable string.
String generateString(String value) {
  const backslash = '__BACKSLASH__';
  assert(
    !value.contains(backslash),
    'Input string cannot contain the sequence: '
    '"__BACKSLASH__", as it is used as part of '
    'backslash character processing.',
  );

  value = value
      // Replace backslashes with a placeholder for now to properly parse
      // other special characters.
      .replaceAll(r'\', backslash)
      .replaceAll(r'$', r'\$')
      .replaceAll("'", r"\'")
      .replaceAll('"', r'\"')
      .replaceAll('\n', r'\n')
      .replaceAll('\f', r'\f')
      .replaceAll('\t', r'\t')
      .replaceAll('\r', r'\r')
      .replaceAll('\b', r'\b')
      // Reintroduce escaped backslashes into generated Dart string.
      .replaceAll(backslash, r'\\');

  return value;
}

/// Given a list of normal strings or interpolated variables, concatenate them
/// into a single dart string to be returned.
String generateReturnExpr(List<String> expressions, {bool isSingleStringVar = false}) {
  if (expressions.isEmpty) {
    return "''";
  } else if (isSingleStringVar) {
    // If our expression is "$varName" where varName is a String, this is equivalent to just varName.
    return expressions[0].substring(1);
  } else {
    final String string = expressions.reversed.fold<String>('', (String string, String expression) {
      if (expression[0] != r'$') {
        return expression + string;
      }
      final alphanumeric = RegExp(r'^([0-9a-zA-Z]|_)+$');
      if (alphanumeric.hasMatch(expression.substring(1)) && !(string.isNotEmpty && alphanumeric.hasMatch(string[0]))) {
        return '$expression$string';
      } else {
        return '\${${expression.substring(1)}}$string';
      }
    });
    return "'$string'";
  }
}

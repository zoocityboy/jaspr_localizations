import 'package:intl/locale.dart' as intl;

/// Represents a locale with language code and optional country code.
///
/// A [Locale] object identifies a specific geographical, political,
/// or cultural region. It consists of a language code and optionally
/// a country code, script code, and variants.
///
/// The language code is a lowercase two-letter code defined by ISO 639-1.
/// The country code is an uppercase two-letter code defined by ISO 3166-1.
///
/// ### Usage Examples
///
/// ```dart
/// // Simple language code
/// const locale = Locale('en');
///
/// // Language with country code
/// const locale = Locale('en', 'US');
///
/// // From language tag
/// final locale = Locale.fromLanguageTag('en_US');
///
/// // From subtags
/// final locale = Locale.fromSubtags(
///   languageCode: 'zh',
///   scriptCode: 'Hans',
///   countryCode: 'CN',
/// );
/// ```
///
/// See also:
/// * [intl.Locale], the underlying intl package Locale class
/// * [Locale.fromLanguageTag], for creating locales from IETF language tags
/// * [Locale.fromSubtags], for creating locales with explicit subtags
class Locale implements intl.Locale {
  /// Creates a locale with the specified [languageCode] and optional [countryCode].
  ///
  /// The [languageCode] argument must not be null. It should be a lowercase
  /// two-letter ISO 639-1 language code (e.g., 'en', 'es', 'zh').
  ///
  /// The [countryCode] is optional and should be an uppercase two-letter
  /// ISO 3166-1 country code (e.g., 'US', 'GB', 'CN').
  ///
  /// The [scriptCode] is optional and identifies the script used for writing
  /// the language (e.g., 'Hans' for simplified Chinese, 'Latn' for Latin script).
  ///
  /// The [variants] are optional and provide additional, well-recognized
  /// variations that define a language or its dialects.
  ///
  /// ### Example
  ///
  /// ```dart
  /// const en = Locale('en');
  /// const enUS = Locale('en', 'US');
  /// const zhHans = Locale('zh', 'CN', 'Hans');
  /// ```
  const Locale(
    this.languageCode, [
    this.countryCode,
    this.scriptCode,
    this.variants = const [],
  ]);

  /// Creates a [Locale] from a language tag string.
  ///
  /// The [tag] should be in the format 'languageCode' or 'languageCode_COUNTRYCODE'.
  /// Parts are separated by underscores.
  ///
  /// Throws [ArgumentError] if the tag format is invalid.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final en = Locale.fromLanguageTag('en');       // Locale('en')
  /// final enUS = Locale.fromLanguageTag('en_US');  // Locale('en', 'US')
  /// ```
  factory Locale.fromLanguageTag(String tag) {
    final parts = tag.split('_');
    if (parts.length == 1) {
      return Locale(parts[0]);
    } else if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    throw ArgumentError('Invalid language tag: $tag');
  }

  /// Creates a [Locale] from explicit subtags.
  ///
  /// The [languageCode] is required and should be a lowercase two-letter
  /// ISO 639-1 language code.
  ///
  /// The [scriptCode] is optional and identifies the script (e.g., 'Hans', 'Hant', 'Latn').
  ///
  /// The [countryCode] is optional and should be an uppercase two-letter
  /// ISO 3166-1 country code.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final locale = Locale.fromSubtags(
  ///   languageCode: 'zh',
  ///   scriptCode: 'Hans',
  ///   countryCode: 'CN',
  /// );
  /// ```
  factory Locale.fromSubtags({
    required String languageCode,
    String? scriptCode,
    String? countryCode,
  }) {
    return Locale(languageCode, countryCode);
  }

  /// Returns the locale identifier as an IETF language tag.
  ///
  /// The format is 'languageCode_COUNTRYCODE' if a country code is specified,
  /// or just 'languageCode' otherwise.
  ///
  /// ### Example
  ///
  /// ```dart
  /// const Locale('en').toLanguageTag();       // 'en'
  /// const Locale('en', 'US').toLanguageTag(); // 'en_US'
  /// ```
  @override
  String toLanguageTag() {
    return countryCode != null ? '${languageCode}_$countryCode' : languageCode;
  }

  /// Compares this locale to another for equality.
  ///
  /// Two locales are equal if they have the same language code, country code,
  /// script code, and variants.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Locale &&
        other.languageCode == languageCode &&
        other.countryCode == countryCode &&
        other.scriptCode == scriptCode &&
        other.variants == variants;
  }

  /// Returns a hash code for this locale.
  @override
  int get hashCode =>
      Object.hash(languageCode, countryCode, scriptCode, variants);

  /// Returns a string representation of this locale.
  ///
  /// Delegates to [toLanguageTag] to produce the string form.
  @override
  String toString() => toLanguageTag();

  /// The script code for this locale.
  ///
  /// This is an optional four-letter code that identifies the script
  /// used to write the language (e.g., 'Hans' for simplified Chinese,
  /// 'Hant' for traditional Chinese, 'Latn' for Latin script).
  @override
  final String? scriptCode;

  /// Additional variants that define language dialects.
  ///
  /// Variants are optional and provide well-recognized variations
  /// that further specify the language or locale.
  @override
  final Iterable<String> variants;

  /// The country code for this locale.
  ///
  /// This is an optional uppercase two-letter ISO 3166-1 country code
  /// (e.g., 'US', 'GB', 'CN').
  @override
  final String? countryCode;

  /// The language code for this locale.
  ///
  /// This is a required lowercase two-letter ISO 639-1 language code
  /// (e.g., 'en', 'es', 'zh').
  @override
  final String languageCode;
}

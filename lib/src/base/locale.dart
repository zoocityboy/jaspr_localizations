import 'package:intl/locale.dart' as intl;

/// Represents a locale with language code and optional country code
class Locale implements intl.Locale {
  const Locale(
    this.languageCode, [
    this.countryCode,
    this.scriptCode,
    this.variants = const [],
  ]);

  /// Creates a Locale from a language tag (e.g., 'en_US' or 'en')
  factory Locale.fromLanguageTag(String tag) {
    final parts = tag.split('_');
    if (parts.length == 1) {
      return Locale(parts[0]);
    } else if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    throw ArgumentError('Invalid language tag: $tag');
  }

  factory Locale.fromSubtags({
    required String languageCode,
    String? scriptCode,
    String? countryCode,
  }) {
    return Locale(languageCode, countryCode);
  }

  /// Returns the locale identifier in the form 'languageCode_COUNTRYCODE'
  /// or just 'languageCode' if no country code is specified
  @override
  String toLanguageTag() {
    return countryCode != null ? '${languageCode}_$countryCode' : languageCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Locale &&
        other.languageCode == languageCode &&
        other.countryCode == countryCode &&
        other.scriptCode == scriptCode &&
        other.variants == variants;
  }

  @override
  int get hashCode =>
      Object.hash(languageCode, countryCode, scriptCode, variants);

  @override
  String toString() => toLanguageTag();

  @override
  final String? scriptCode;

  @override
  final Iterable<String> variants;

  @override
  final String? countryCode;

  @override
  final String languageCode;
}

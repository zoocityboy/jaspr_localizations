// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:example/components/language.dart' as prefix0;
import 'package:example/pages/home.dart' as prefix1;
import 'package:example/app.dart' as prefix2;

/// Default [JasprOptions] for use with your jaspr project.
///
/// Use this to initialize jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'jaspr_options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultJasprOptions,
///   );
///
///   runApp(...);
/// }
/// ```
JasprOptions get defaultJasprOptions => JasprOptions(
  clients: {
    prefix2.App: ClientTarget<prefix2.App>('app'),

    prefix0.LanguageComponent: ClientTarget<prefix0.LanguageComponent>(
      'components/language',
    ),

    prefix1.Home: ClientTarget<prefix1.Home>('pages/home'),
  },
  styles: () => [...prefix0.LanguageComponent.styles, ...prefix2.App.styles],
);

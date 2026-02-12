# Product Context

## Problem
Standard Flutter localization tools (`flutter_localizations`) depend on `flutter` which includes `dart:ui`. Jaspr is a web framework that may not stick to Flutter's exact rendering pipeline or dependencies, and using Flutter packages in a pure Jaspr web app can be heavy or incompatible. Jaspr needs a native way to handle localization that fits its component model.

## Solution
A dedicated package `jaspr_localizations` that:
1.  Uses the standard `.arb` format familiar to Dart/Flutter devs.
2.  Generates code that doesn't depend on Flutter widgets.
3.  Provides a context-aware way to access translations in Jaspr components.

## User Experience
- **Developer**: Adds package, configures `l10n.yaml` (or build config), creates `app_en.arb`, runs build, uses `AppLocalizations.of(context).helloWorld`.
- **End User**: Sees the app in their preferred language automatically or via manual switch.

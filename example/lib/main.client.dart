/// The entrypoint for the **client** environment.
///
/// The [main] method will only be executed on the client when loading the page.
/// To run code on the server during pre-rendering, check the `main.server.dart` file.
library;

import 'package:example/l10n/generated/app_l10n.dart';
import 'package:jaspr/client.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.client.options.dart';

void main() {
  // Initializes the client environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultClientOptions,
  );

  // Starts the app.
  //
  // [ClientApp] automatically loads and renders all components annotated with @client.
  //
  // You can wrap this with additional [InheritedComponent]s to share state across multiple
  // @client components if needed.
  runApp(
    // JasprLocalizations(
    //   supportedLocales: AppL10nDelegate.supportedLocales,
    //   delegates: [AppL10n.delegate],
    //   builder: (context, locale) {
    //     return const ClientApp();
    //   },
    // ),
    const ClientApp()
  );
}

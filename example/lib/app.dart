import 'package:example/l10n/generated/app_l10n.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'pages/home.dart';

// The main component of your application.
//
// By using multi-page routing, this component will only be built on the server during pre-rendering and
// **not** executed on the client. Instead only the nested [Home] and [About] components will be mounted on the client.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    // Use LocalizationApp for automatic locale switching and rebuilding
    return JasprLocalizations(
      supportedLocales: AppL10nDelegate.supportedLocales,
      delegates: [AppL10n.delegate],
      builder: (context, locale) {
        return div(classes: 'main', [
          Router(
            routes: [
              Route(
                path: '/',
                title: 'Home',
                builder: (context, state) => const Home(),
              ),
            ],
          ),
        ]);
      },
    );
  }

  // Defines the css styles for elements of this component.
  //
  // By using the @css annotation, these will be rendered automatically to css inside the <head> of your page.
  // Must be a variable or getter of type [List<StyleRule>].
  @css
  static List<StyleRule> get styles => [
    css('.main', [
      // The '&' refers to the parent selector of a nested style rules.
      css('&').styles(
        display: Display.flex,
        height: 100.vh,
        padding: Spacing.all(16.px),
        flexDirection: FlexDirection.column,
        flexWrap: FlexWrap.wrap,
      ),
      css('section').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        justifyContent: JustifyContent.start,
        alignItems: AlignItems.start,
        flex: Flex(grow: 1),
      ),
    ]),
  ];
}

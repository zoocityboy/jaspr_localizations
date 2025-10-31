import 'package:example/generated/l10n.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'pages/home.dart';

// The main component of your application.
//
// By using multi-page routing, this component will only be built on the server during pre-rendering and
// **not** executed on the client. Instead only the nested [Home] and [About] components will be mounted on the client.
@client
class App extends StatefulComponent {
  const App({super.key});

  @override
  State createState() => AppState();
}

class AppState extends State<App> {
  late Locale currentLocale;
  late List<Locale> supportedLocales;

  @override
  void initState() {
    supportedLocales = L10nDelegate.supportedLocales;
    currentLocale = supportedLocales.first;
    super.initState();
  }

  @override
  Component build(BuildContext context) {
    // Use LocalizationApp for automatic locale switching and rebuilding
    return JasprLocalizations(
      supportedLocales: supportedLocales,
      initialLocale: currentLocale,
      delegates: const [L10nDelegate()],
      builder: (context, locale) => div(classes: 'main', [
        Router(
          routes: [
            Route(path: '/', title: 'Home', builder: (context, state) => const Home()),
          ],
        ),
      ]),
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
        flexDirection: FlexDirection.column,
        flexWrap: FlexWrap.wrap,
      ),
      css('section').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        justifyContent: JustifyContent.center,
        alignItems: AlignItems.center,
        flex: Flex(grow: 1),
      ),
    ]),
  ];
}

import 'package:example/l10n/generated/app_l10n.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';

import '../components/language.dart';

// By using the @client annotation this component will be automatically compiled to javascript and mounted
// on the client. Therefore:
// - this file and any imported file must be compilable for both server and client environments.
// - this component and any child components will be built once on the server during pre-rendering and then
//   again on the client during normal rendering.
class Home extends StatefulComponent {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();

  @css
  static List<StyleRule> get styles => [
    css('.row').styles(
      display: Display.flex,
      padding: Spacing.all(16.px),
      flexDirection: FlexDirection.row,
      flexWrap: FlexWrap.wrap,
      gap: Gap.all(50.px),
    ),
  ];
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Run code depending on the rendering environment.
    if (kIsWeb) {
      print("Hello client");
      // When using @client components there is no default `main()` function on the client where you would normally
      // run any client-side initialization logic. Instead you can put it here, considering this component is only
      // mounted once at the root of your client-side component tree.
    } else {
      print("Hello server");
    }
  }

  @override
  Component build(BuildContext context) {
    final l10n = AppL10n.of(context)!;

    return section(
      [
        img(src: 'images/logo.svg', width: 80),
        h1([Component.text(l10n.welcome)]),
        p([Component.text(l10n.successCreation)]),
        div(styles: Styles(height: 100.px), []),

        div(classes: 'row', [
          const LanguageComponent(),

        
          JasprLocalizations.withLocale(
          locale: AppL10nDelegate.supportedLocales.last,
            child: LanguageComponent(),
          ),
        ]),
        
        div(styles: Styles(height: 50.px), []),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [];
}

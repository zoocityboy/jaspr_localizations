import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:jaspr_localizations/src/base/locale_change_notifier.dart';
import 'package:jaspr_localizations/src/jaspr_l10n_core.dart';

/// A component that rebuilds its child when the locale changes.
class JasprLocaleBuilder extends StatefulComponent {
  /// Creates a [JasprLocaleBuilder].
  const JasprLocaleBuilder({required this.builder, this.controller, super.key});

  /// The builder function.
  final Component Function(BuildContext, Locale) builder;

  /// Optional controller. If null, looks up the provider in the context.
  final LocaleChangeNotifier? controller;

  @override
  State<JasprLocaleBuilder> createState() => _LocaleBuilderState();
}

class _LocaleBuilderState extends State<JasprLocaleBuilder> {
  LocaleChangeNotifier? _controller;
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  @override
  void didUpdateComponent(JasprLocaleBuilder oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.controller != component.controller) {
      _teardownController();
      _setupController();
    }
  }

  @override
  void dispose() {
    _teardownController();
    super.dispose();
  }

  void _setupController() {
    _controller =
        component.controller ?? JasprLocalizationProvider.controllerOf(context);
    if (_controller != null) {
      _currentLocale = _controller!.currentLocale;
      _controller!.addListener(_onLocaleChanged);
    }
  }

  void _teardownController() {
    _controller?.removeListener(_onLocaleChanged);
    _controller = null;
  }

  void _onLocaleChanged() {
    print(
      '_LocaleBuilderState: _onLocaleChanged called, mounted=$mounted, controller=${_controller != null}',
    );
    if (mounted && _controller != null) {
      final newLocale = _controller!.currentLocale;
      print(
        '_LocaleBuilderState: Setting state with new locale: ${newLocale.toLanguageTag()}',
      );
      setState(() {
        _currentLocale = newLocale;
      });
      print(
        '_LocaleBuilderState: State updated, currentLocale=${_currentLocale?.toLanguageTag()}',
      );
    }
  }

  @override
  Component build(BuildContext context) {
    final locale =
        _currentLocale ?? JasprLocalizationProvider.of(context).currentLocale;
    return component.builder(context, locale);
  }
}

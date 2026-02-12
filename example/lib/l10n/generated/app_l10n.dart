// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';

abstract class AppL10n {
  AppL10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  /// Retrieve the [AppL10n] instance from the context.
  static AppL10n? of(BuildContext context) {
    // For Jaspr, we can't use Localizations.of() like Flutter
    // This would need to be implemented using Jaspr's provider system
    // For now, return null and let consumers handle this
    final provider = JasprLocalizationProvider.of(context);
    final currentLocale = provider.currentLocale;
    return AppL10n.from(currentLocale.languageCode);
  }

  /// The delegate for this localizations class.
  static const AppL10nDelegate delegate = AppL10nDelegate();

  /// A list of this localizations delegate along with default delegates.
  static const List<dynamic> localizationsDelegates = <dynamic>[
    delegate,
    // Additional delegates would go here for Jaspr framework
  ];

  /// A list of supported locales.
  static const List<String> supportedLocales = <String>[
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'pl',
    'sk',
    'zh',
  ];

  /// A factory constructor to construct specific subclasses base on a locale.
  static AppL10n from(String locale) {
    switch (locale) {
      case 'cs':
        return _AppL10nCs();
      case 'de':
        return _AppL10nDe();
      case 'en':
        return _AppL10nEn();
      case 'es':
        return _AppL10nEs();
      case 'fr':
        return _AppL10nFr();
      case 'pl':
        return _AppL10nPl();
      case 'sk':
        return _AppL10nSk();
      case 'zh':
        return _AppL10nZh();

      default:
        return _AppL10nEn();
    }
  }

  /// The title of the application displayed in the header
  ///
  /// context: ui:header
  ///
  /// In en, this message translates to:
  /// **'My Application Updates'**
  String get appTitle;

  /// Welcome header on the home page
  ///
  /// context: ui:home:header
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Success message displayed on home page showing creation status
  ///
  /// context: ui:home:content
  ///
  /// In en, this message translates to:
  /// **'You successfully create a new Jaspr site with jaspr_localizations.'**
  String get successCreation;

  /// Welcome message shown to users when they open the application
  ///
  /// context: ui:greeting
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}!'**
  String welcomeMessage(String appName);

  /// Shows the number of items with proper plural support
  ///
  /// context: ui:status
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{One item} other{{count} items}}'**
  String itemCount(int count);

  /// Header for the language selector section
  ///
  /// context: ui:settings
  ///
  /// In en, this message translates to:
  /// **'Language Switcher'**
  String get languageSwitcher;

  /// Label indicating the currently selected option
  ///
  /// context: ui:status
  ///
  /// In en, this message translates to:
  /// **' (current)'**
  String get currentLabel;

  /// Text for the login button
  ///
  /// context: ui:button:auth
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Text for the logout button
  ///
  /// context: ui:button:auth
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// Displays the current locale setting
  ///
  /// context: ui:settings
  ///
  /// In en, this message translates to:
  /// **'Current locale: {locale}'**
  String currentLocale(String locale);

  /// Gender-specific message demonstrating ICU select format
  ///
  /// context: example:icu
  ///
  /// In en, this message translates to:
  /// **'{gender, select, male{He likes Jaspr} female{She likes Jaspr} other{They like Jaspr}}'**
  String genderMessage(String gender);

  /// Display price with currency formatting
  ///
  /// context: ui:commerce
  ///
  /// In en, this message translates to:
  /// **'Price: {amount}'**
  String priceDisplay(num amount);

  /// Display download count with number formatting
  ///
  /// context: ui:stats
  ///
  /// In en, this message translates to:
  /// **'Downloads: {count}'**
  String downloadCount(String count);

  /// Display percentage value with proper formatting
  ///
  /// context: ui:progress
  ///
  /// In en, this message translates to:
  /// **'Progress: {value}%'**
  String percentageValue(num value);

  /// Complex sales report with multiple formatting types
  ///
  /// context: ui:reporting
  ///
  /// In en, this message translates to:
  /// **'Sales: {amount} ({count} units) - {percent}% growth'**
  String salesReport(num amount, num count, num percent);

  /// Shows when the data was last updated
  ///
  /// context: ui:timestamp
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(DateTime date);

  /// Display remaining time in hours and minutes
  ///
  /// context: ui:timer
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}'**
  String timeRemaining(DateTime time);

  /// Label for activity details when the date is the same day and start time is different from end time
  ///
  /// In en, this message translates to:
  /// **'{date}: {startTime} to {endTime}'**
  String activityDetailsDateSameDayWithTime(DateTime date, DateTime startTime, DateTime endTime);
}

/// Delegate class for AppL10n localizations.
class AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const AppL10nDelegate();

  /// A list of supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pl'),
    Locale('sk'),
    Locale('zh'),
  ];

  /// Whether this delegate supports the given locale.
  @override
  bool isSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }

  /// Load the localizations for the given locale.
  @override
  Future<AppL10n> load(Locale locale) async {
    return AppL10n.from(locale.toLanguageTag());
  }
}

class _AppL10nCs extends AppL10n {
  _AppL10nCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Moje aplikace';

  @override
  String get welcome => 'Vítejte';

  @override
  String get successCreation => 'Úspěšně jste vytvořili novou stránku Jaspr pomocí jaspr_localizations.';

  @override
  String welcomeMessage(String appName) {
    return 'Vítejte v aplikaci ${appName}!';
  }

  @override
  String itemCount(int count) {
    return '${intl.Intl.plural(
      count,
      zero: 'Žádné položky',
      one: 'Jedna položka',
      few: '${count.toString()} položky',
      other: '${count.toString()} položek',
      name: 'itemCount',
      locale: localeName,
    )}';
  }

  @override
  String get languageSwitcher => 'Přepínač jazyků';

  @override
  String get currentLabel => ' (aktuální)';

  @override
  String get loginButton => 'Přihlásit se';

  @override
  String get logoutButton => 'Odhlásit se';

  @override
  String currentLocale(String locale) {
    return 'Aktuální lokalita: ${locale}';
  }

  @override
  String genderMessage(String gender) {
    return '${intl.Intl.select(
      gender,
      {'male': 'Má rád Jaspr', 'female': 'Má ráda Jaspr', 'other': 'Mají rádi Jaspr'},
      name: 'genderMessage',
    )}';
  }

  @override
  String priceDisplay(num amount) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.currency(locale: localeName);
    return 'Cena: ${amountFormatter.format(amount)}';
  }

  @override
  String downloadCount(String count) {
    return 'Stažení: ${count}';
  }

  @override
  String percentageValue(num value) {
    return 'Průběh: ${value.toString()}%';
  }

  @override
  String salesReport(num amount, num count, num percent) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    final intl.NumberFormat countFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    return 'Prodeje: ${amountFormatter.format(amount)} (${countFormatter.format(count)} kusů) - růst ${percent.toString()}%';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMd(localeName);

    return 'Naposledy aktualizováno: ${dateFormatter.format(date)}';
  }

  @override
  String timeRemaining(DateTime time) {
    final intl.DateFormat timeFormatter = intl.DateFormat.Hm(localeName);

    return 'Zbývající čas: ${timeFormatter.format(time)}';
  }

  @override
  String activityDetailsDateSameDayWithTime(DateTime date, DateTime startTime, DateTime endTime) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMMMMEEEEd(localeName);
    final intl.DateFormat startTimeFormatter = intl.DateFormat.jm(localeName);
    final intl.DateFormat endTimeFormatter = intl.DateFormat.jm(localeName);

    return '${dateFormatter.format(date)}: ${startTimeFormatter.format(startTime)} to ${endTimeFormatter.format(endTime)}';
  }
}

class _AppL10nDe extends AppL10n {
  _AppL10nDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Meine Anwendung';

  @override
  String get welcome => 'Willkommen';

  @override
  String get successCreation => 'Sie haben erfolgreich eine neue Jaspr-Website mit jaspr_localizations erstellt.';

  @override
  String welcomeMessage(String appName) {
    return 'Willkommen bei ${appName}!';
  }

  @override
  String itemCount(int count) {
    return '${intl.Intl.plural(
      count,
      zero: 'Keine Elemente',
      one: 'Ein Element',
      other: '${count.toString()} Elemente',
      name: 'itemCount',
      locale: localeName,
    )}';
  }

  @override
  String get languageSwitcher => 'Sprachumschalter';

  @override
  String get currentLabel => ' (aktuell)';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get logoutButton => 'Abmelden';

  @override
  String currentLocale(String locale) {
    return 'Aktuelle Sprache: ${locale}';
  }

  @override
  String genderMessage(String gender) {
    return '${intl.Intl.select(
      gender,
      {'male': 'Er mag Jaspr', 'female': 'Sie mag Jaspr', 'other': 'Sie mögen Jaspr'},
      name: 'genderMessage',
    )}';
  }

  @override
  String priceDisplay(num amount) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.currency(locale: localeName);
    return 'Preis: ${amountFormatter.format(amount)}';
  }

  @override
  String downloadCount(String count) {
    return 'Downloads: ${count}';
  }

  @override
  String percentageValue(num value) {
    return 'Fortschritt: ${value.toString()}%';
  }

  @override
  String salesReport(num amount, num count, num percent) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    final intl.NumberFormat countFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    return 'Verkäufe: ${amountFormatter.format(amount)} (${countFormatter.format(count)} Einheiten) - ${percent.toString()}% Wachstum';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMd(localeName);

    return 'Zuletzt aktualisiert: ${dateFormatter.format(date)}';
  }

  @override
  String timeRemaining(DateTime time) {
    final intl.DateFormat timeFormatter = intl.DateFormat.Hm(localeName);

    return 'Verbleibende Zeit: ${timeFormatter.format(time)}';
  }

  @override
  String activityDetailsDateSameDayWithTime(DateTime date, DateTime startTime, DateTime endTime) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMMMMEEEEd(localeName);
    final intl.DateFormat startTimeFormatter = intl.DateFormat.jm(localeName);
    final intl.DateFormat endTimeFormatter = intl.DateFormat.jm(localeName);

    return '${dateFormatter.format(date)}: ${startTimeFormatter.format(startTime)} to ${endTimeFormatter.format(endTime)}';
  }
}

class _AppL10nEn extends AppL10n {
  _AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Application Updates';

  @override
  String get welcome => 'Welcome';

  @override
  String get successCreation => 'You successfully create a new Jaspr site with jaspr_localizations.';

  @override
  String welcomeMessage(String appName) {
    return 'Welcome to ${appName}!';
  }

  @override
  String itemCount(int count) {
    return '${intl.Intl.plural(
      count,
      zero: 'No items',
      one: 'One item',
      other: '${count.toString()} items',
      name: 'itemCount',
      locale: localeName,
    )}';
  }

  @override
  String get languageSwitcher => 'Language Switcher';

  @override
  String get currentLabel => ' (current)';

  @override
  String get loginButton => 'Login';

  @override
  String get logoutButton => 'Logout';

  @override
  String currentLocale(String locale) {
    return 'Current locale: ${locale}';
  }

  @override
  String genderMessage(String gender) {
    return '${intl.Intl.select(
      gender,
      {'male': 'He likes Jaspr', 'female': 'She likes Jaspr', 'other': 'They like Jaspr'},
      name: 'genderMessage',
    )}';
  }

  @override
  String priceDisplay(num amount) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.currency(locale: localeName);
    return 'Price: ${amountFormatter.format(amount)}';
  }

  @override
  String downloadCount(String count) {
    return 'Downloads: ${count}';
  }

  @override
  String percentageValue(num value) {
    return 'Progress: ${value.toString()}%';
  }

  @override
  String salesReport(num amount, num count, num percent) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    final intl.NumberFormat countFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    return 'Sales: ${amountFormatter.format(amount)} (${countFormatter.format(count)} units) - ${percent.toString()}% growth';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMd(localeName);

    return 'Last updated: ${dateFormatter.format(date)}';
  }

  @override
  String timeRemaining(DateTime time) {
    final intl.DateFormat timeFormatter = intl.DateFormat.Hm(localeName);

    return 'Time remaining: ${timeFormatter.format(time)}';
  }

  @override
  String activityDetailsDateSameDayWithTime(DateTime date, DateTime startTime, DateTime endTime) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMMMMEEEEd(localeName);
    final intl.DateFormat startTimeFormatter = intl.DateFormat.jm(localeName);
    final intl.DateFormat endTimeFormatter = intl.DateFormat.jm(localeName);

    return '${dateFormatter.format(date)}: ${startTimeFormatter.format(startTime)} to ${endTimeFormatter.format(endTime)}';
  }
}

class _AppL10nEs extends AppL10n {
  _AppL10nEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi Aplicación';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get successCreation => 'Has creado con éxito un nuevo sitio Jaspr con jaspr_localizations.';

  @override
  String welcomeMessage(String appName) {
    return '¡Bienvenido a ${appName}!';
  }

  @override
  String itemCount(int count) {
    return '${intl.Intl.plural(
      count,
      zero: 'Ningún elemento',
      one: 'Un elemento',
      other: '${count.toString()} elementos',
      name: 'itemCount',
      locale: localeName,
    )}';
  }

  @override
  String get languageSwitcher => 'Selector de idioma';

  @override
  String get currentLabel => ' (actual)';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get logoutButton => 'Cerrar sesión';

  @override
  String currentLocale(String locale) {
    return 'Idioma actual: ${locale}';
  }

  @override
  String genderMessage(String gender) {
    return '${intl.Intl.select(
      gender,
      {'male': 'A él le gusta Jaspr', 'female': 'A ella le gusta Jaspr', 'other': 'A ellos les gusta Jaspr'},
      name: 'genderMessage',
    )}';
  }

  @override
  String priceDisplay(num amount) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.currency(locale: localeName);
    return 'Precio: ${amountFormatter.format(amount)}';
  }

  @override
  String downloadCount(String count) {
    return 'Descargas: ${count}';
  }

  @override
  String percentageValue(num value) {
    return 'Progreso: ${value.toString()}%';
  }

  @override
  String salesReport(num amount, num count, num percent) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    final intl.NumberFormat countFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    return 'Ventas: ${amountFormatter.format(amount)} (${countFormatter.format(count)} unidades) - ${percent.toString()}% crecimiento';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMd(localeName);

    return 'Última actualización: ${dateFormatter.format(date)}';
  }

  @override
  String timeRemaining(DateTime time) {
    final intl.DateFormat timeFormatter = intl.DateFormat.Hm(localeName);

    return 'Tiempo restante: ${timeFormatter.format(time)}';
  }

  @override
  String activityDetailsDateSameDayWithTime(DateTime date, DateTime startTime, DateTime endTime) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMMMMEEEEd(localeName);
    final intl.DateFormat startTimeFormatter = intl.DateFormat.jm(localeName);
    final intl.DateFormat endTimeFormatter = intl.DateFormat.jm(localeName);

    return '${dateFormatter.format(date)}: ${startTimeFormatter.format(startTime)} to ${endTimeFormatter.format(endTime)}';
  }
}

class _AppL10nFr extends AppL10n {
  _AppL10nFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mon Application';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get successCreation => 'Vous avez créé avec succès un nouveau site Jaspr avec jaspr_localizations.';

  @override
  String welcomeMessage(String appName) {
    return 'Bienvenue sur ${appName}!';
  }

  @override
  String itemCount(int count) {
    return '${intl.Intl.plural(
      count,
      zero: 'Aucun élément',
      one: 'Un élément',
      other: '${count.toString()} éléments',
      name: 'itemCount',
      locale: localeName,
    )}';
  }

  @override
  String get languageSwitcher => 'Sélecteur de langue';

  @override
  String get currentLabel => ' (actuel)';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get logoutButton => 'Se déconnecter';

  @override
  String currentLocale(String locale) {
    return 'Langue actuelle: ${locale}';
  }

  @override
  String genderMessage(String gender) {
    return '${intl.Intl.select(
      gender,
      {'male': 'Il aime Jaspr', 'female': 'Elle aime Jaspr', 'other': 'Ils aiment Jaspr'},
      name: 'genderMessage',
    )}';
  }

  @override
  String priceDisplay(num amount) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.currency(locale: localeName);
    return 'Prix: ${amountFormatter.format(amount)}';
  }

  @override
  String downloadCount(String count) {
    return 'Téléchargements: ${count}';
  }

  @override
  String percentageValue(num value) {
    return 'Progrès: ${value.toString()}%';
  }

  @override
  String salesReport(num amount, num count, num percent) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    final intl.NumberFormat countFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    return 'Ventes: ${amountFormatter.format(amount)} (${countFormatter.format(count)} unités) - ${percent.toString()}% croissance';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMd(localeName);

    return 'Dernière mise à jour: ${dateFormatter.format(date)}';
  }

  @override
  String timeRemaining(DateTime time) {
    final intl.DateFormat timeFormatter = intl.DateFormat.Hm(localeName);

    return 'Temps restant: ${timeFormatter.format(time)}';
  }

  @override
  String activityDetailsDateSameDayWithTime(DateTime date, DateTime startTime, DateTime endTime) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMMMMEEEEd(localeName);
    final intl.DateFormat startTimeFormatter = intl.DateFormat.jm(localeName);
    final intl.DateFormat endTimeFormatter = intl.DateFormat.jm(localeName);

    return '${dateFormatter.format(date)}: ${startTimeFormatter.format(startTime)} to ${endTimeFormatter.format(endTime)}';
  }
}

class _AppL10nPl extends AppL10n {
  _AppL10nPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Moja aplikacja';

  @override
  String get welcome => 'Witaj';

  @override
  String get successCreation => 'Pomyślnie utworzyłeś nową stronę Jaspr z jaspr_localizations.';

  @override
  String welcomeMessage(String appName) {
    return 'Witamy w aplikacji ${appName}!';
  }

  @override
  String itemCount(int count) {
    return '${intl.Intl.plural(
      count,
      zero: 'Brak elementów',
      one: 'Jeden element',
      few: '${count.toString()} elementy',
      many: '${count.toString()} elementów',
      other: '${count.toString()} elementów',
      name: 'itemCount',
      locale: localeName,
    )}';
  }

  @override
  String get languageSwitcher => 'Przełącznik języka';

  @override
  String get currentLabel => ' (obecny)';

  @override
  String get loginButton => 'Zaloguj się';

  @override
  String get logoutButton => 'Wyloguj się';

  @override
  String currentLocale(String locale) {
    return 'Bieżąca lokalizacja: ${locale}';
  }

  @override
  String genderMessage(String gender) {
    return '${intl.Intl.select(
      gender,
      {'male': 'On lubi Jaspr', 'female': 'Ona lubi Jaspr', 'other': 'Oni lubią Jaspr'},
      name: 'genderMessage',
    )}';
  }

  @override
  String priceDisplay(num amount) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.currency(locale: localeName);
    return 'Cena: ${amountFormatter.format(amount)}';
  }

  @override
  String downloadCount(String count) {
    return 'Pobrania: ${count}';
  }

  @override
  String percentageValue(num value) {
    return 'Postęp: ${value.toString()}%';
  }

  @override
  String salesReport(num amount, num count, num percent) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    final intl.NumberFormat countFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    return 'Sprzedaż: ${amountFormatter.format(amount)} (${countFormatter.format(count)} sztuk) - wzrost ${percent.toString()}%';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMd(localeName);

    return 'Ostatnia aktualizacja: ${dateFormatter.format(date)}';
  }

  @override
  String timeRemaining(DateTime time) {
    final intl.DateFormat timeFormatter = intl.DateFormat.Hm(localeName);

    return 'Pozostały czas: ${timeFormatter.format(time)}';
  }

  @override
  String activityDetailsDateSameDayWithTime(DateTime date, DateTime startTime, DateTime endTime) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMMMMEEEEd(localeName);
    final intl.DateFormat startTimeFormatter = intl.DateFormat.jm(localeName);
    final intl.DateFormat endTimeFormatter = intl.DateFormat.jm(localeName);

    return '${dateFormatter.format(date)}: ${startTimeFormatter.format(startTime)} to ${endTimeFormatter.format(endTime)}';
  }
}

class _AppL10nSk extends AppL10n {
  _AppL10nSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'Moja aplikácia';

  @override
  String get welcome => 'Vitajte';

  @override
  String get successCreation => 'Úspešne ste vytvorili novú stránku Jaspr s jaspr_localizations.';

  @override
  String welcomeMessage(String appName) {
    return 'Vitajte v aplikácii ${appName}!';
  }

  @override
  String itemCount(int count) {
    return '${intl.Intl.plural(
      count,
      zero: 'Žiadne položky',
      one: 'Jedna položka',
      few: '${count.toString()} položky',
      other: '${count.toString()} položiek',
      name: 'itemCount',
      locale: localeName,
    )}';
  }

  @override
  String get languageSwitcher => 'Prepínač jazykov';

  @override
  String get currentLabel => ' (aktuálny)';

  @override
  String get loginButton => 'Prihlásiť sa';

  @override
  String get logoutButton => 'Odhlásiť sa';

  @override
  String currentLocale(String locale) {
    return 'Aktuálne miestne nastavenie: ${locale}';
  }

  @override
  String genderMessage(String gender) {
    return '${intl.Intl.select(
      gender,
      {'male': 'Má rád Jaspr', 'female': 'Má rada Jaspr', 'other': 'Majú radi Jaspr'},
      name: 'genderMessage',
    )}';
  }

  @override
  String priceDisplay(num amount) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.currency(locale: localeName);
    return 'Cena: ${amountFormatter.format(amount)}';
  }

  @override
  String downloadCount(String count) {
    return 'Stiahnutia: ${count}';
  }

  @override
  String percentageValue(num value) {
    return 'Pokrok: ${value.toString()}%';
  }

  @override
  String salesReport(num amount, num count, num percent) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    final intl.NumberFormat countFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    return 'Predaje: ${amountFormatter.format(amount)} (${countFormatter.format(count)} kusov) - rast ${percent.toString()}%';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMd(localeName);

    return 'Naposledy aktualizované: ${dateFormatter.format(date)}';
  }

  @override
  String timeRemaining(DateTime time) {
    final intl.DateFormat timeFormatter = intl.DateFormat.Hm(localeName);

    return 'Zostávajúci čas: ${timeFormatter.format(time)}';
  }

  @override
  String activityDetailsDateSameDayWithTime(DateTime date, DateTime startTime, DateTime endTime) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMMMMEEEEd(localeName);
    final intl.DateFormat startTimeFormatter = intl.DateFormat.jm(localeName);
    final intl.DateFormat endTimeFormatter = intl.DateFormat.jm(localeName);

    return '${dateFormatter.format(date)}: ${startTimeFormatter.format(startTime)} to ${endTimeFormatter.format(endTime)}';
  }
}

class _AppL10nZh extends AppL10n {
  _AppL10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '我的应用程序';

  @override
  String get welcome => '欢迎';

  @override
  String get successCreation => '您已成功使用 jaspr_localizations 创建了一个新的 Jaspr 站点。';

  @override
  String welcomeMessage(String appName) {
    return '欢迎使用 ${appName}！';
  }

  @override
  String itemCount(int count) {
    return '${intl.Intl.plural(
      count,
      zero: '没有项目',
      other: '${count.toString()}个项目',
      name: 'itemCount',
      locale: localeName,
    )}';
  }

  @override
  String get languageSwitcher => '语言切换器';

  @override
  String get currentLabel => ' (当前)';

  @override
  String get loginButton => '登录';

  @override
  String get logoutButton => '退出';

  @override
  String currentLocale(String locale) {
    return '当前语言: ${locale}';
  }

  @override
  String genderMessage(String gender) {
    return '${intl.Intl.select(
      gender,
      {'male': '他喜欢Jaspr', 'female': '她喜欢Jaspr', 'other': '他们喜欢Jaspr'},
      name: 'genderMessage',
    )}';
  }

  @override
  String priceDisplay(num amount) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.currency(locale: localeName);
    return '价格: ${amountFormatter.format(amount)}';
  }

  @override
  String downloadCount(String count) {
    return '下载次数: ${count}';
  }

  @override
  String percentageValue(num value) {
    return '进度: ${value.toString()}%';
  }

  @override
  String salesReport(num amount, num count, num percent) {
    final intl.NumberFormat amountFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    final intl.NumberFormat countFormatter = intl.NumberFormat.simpleCurrency(locale: localeName);
    return '销售额: ${amountFormatter.format(amount)} (${countFormatter.format(count)}个单位) - ${percent.toString()}%增长';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMd(localeName);

    return '最后更新: ${dateFormatter.format(date)}';
  }

  @override
  String timeRemaining(DateTime time) {
    final intl.DateFormat timeFormatter = intl.DateFormat.Hm(localeName);

    return '剩余时间: ${timeFormatter.format(time)}';
  }

  @override
  String activityDetailsDateSameDayWithTime(DateTime date, DateTime startTime, DateTime endTime) {
    final intl.DateFormat dateFormatter = intl.DateFormat.yMMMMEEEEd(localeName);
    final intl.DateFormat startTimeFormatter = intl.DateFormat.jm(localeName);
    final intl.DateFormat endTimeFormatter = intl.DateFormat.jm(localeName);

    return '${dateFormatter.format(date)}: ${startTimeFormatter.format(startTime)} to ${endTimeFormatter.format(endTime)}';
  }
}

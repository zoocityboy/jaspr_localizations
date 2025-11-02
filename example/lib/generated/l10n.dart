// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;
import 'package:jaspr_localizations/jaspr_localizations.dart';

abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  /// Retrieve the [L10n] instance from the context.
  static L10n? of(dynamic context) {
    // For Jaspr, we can't use Localizations.of() like Flutter
    // This would need to be implemented using Jaspr's provider system
    // For now, return null and let consumers handle this
    return null;
  }

  /// The delegate for this localizations class.
  static const L10nDelegate delegate = L10nDelegate();

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
  static L10n from(String locale) {
    switch (locale) {
      case 'cs':
        return L10nCs();
      case 'de':
        return L10nDe();
      case 'en':
        return L10nEn();
      case 'es':
        return L10nEs();
      case 'fr':
        return L10nFr();
      case 'pl':
        return L10nPl();
      case 'sk':
        return L10nSk();
      case 'zh':
        return L10nZh();

      default:
        return L10nEn();
    }
  }

  /// No description provided for appTitle.
  ///
  /// In en, this message translates to:
  /// **'My Application'**
  String get appTitle;

  /// No description provided for welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}!'**
  String welcomeMessage(String appName);

  /// No description provided for itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{One item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for currentLocale.
  ///
  /// In en, this message translates to:
  /// **'Current Locale: {locale}'**
  String currentLocale(String locale);

  /// No description provided for genderMessage.
  ///
  /// In en, this message translates to:
  /// **'{gender, select, male{He likes Flutter} female{She likes Flutter} other{They like Flutter}}'**
  String genderMessage(String gender);

  /// No description provided for priceDisplay.
  ///
  /// In en, this message translates to:
  /// **'Price: {amount}'**
  String priceDisplay(num amount);

  /// No description provided for downloadCount.
  ///
  /// In en, this message translates to:
  /// **'Downloads: {count}'**
  String downloadCount(String count);

  /// No description provided for percentageValue.
  ///
  /// In en, this message translates to:
  /// **'Progress: {value}%'**
  String percentageValue(num value);

  /// No description provided for salesReport.
  ///
  /// In en, this message translates to:
  /// **'Sales: {amount} ({count} units) - {percent}% growth'**
  String salesReport(num amount, num count, num percent);

  /// No description provided for lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(DateTime date);

  /// No description provided for timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}'**
  String timeRemaining(DateTime time);
}

/// Delegate class for L10n localizations.
class L10nDelegate extends LocalizationsDelegate<L10n> {
  const L10nDelegate();

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
  Future<L10n> load(Locale locale) async {
    return L10n.from(locale.toLanguageTag());
  }
}

class L10nCs extends L10n {
  L10nCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Moje aplikace';

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
      {'male': 'Má rád Flutter', 'female': 'Má ráda Flutter', 'other': 'Mají rádi Flutter'},
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
    return 'Naposledy aktualizováno: ${date}';
  }

  @override
  String timeRemaining(DateTime time) {
    return 'Zbývající čas: ${time}';
  }
}

class L10nDe extends L10n {
  L10nDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Meine Anwendung';

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
      {'male': 'Er mag Flutter', 'female': 'Sie mag Flutter', 'other': 'Sie mögen Flutter'},
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
    return 'Zuletzt aktualisiert: ${date}';
  }

  @override
  String timeRemaining(DateTime time) {
    return 'Verbleibende Zeit: ${time}';
  }
}

class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Application';

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
  String get loginButton => 'Login';

  @override
  String get logoutButton => 'Logout';

  @override
  String currentLocale(String locale) {
    return 'Current Locale: ${locale}';
  }

  @override
  String genderMessage(String gender) {
    return '${intl.Intl.select(
      gender,
      {'male': 'He likes Flutter', 'female': 'She likes Flutter', 'other': 'They like Flutter'},
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
    return 'Last updated: ${date}';
  }

  @override
  String timeRemaining(DateTime time) {
    return 'Time remaining: ${time}';
  }
}

class L10nEs extends L10n {
  L10nEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi Aplicación';

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
      {'male': 'A él le gusta Flutter', 'female': 'A ella le gusta Flutter', 'other': 'A ellos les gusta Flutter'},
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
    return 'Última actualización: ${date}';
  }

  @override
  String timeRemaining(DateTime time) {
    return 'Tiempo restante: ${time}';
  }
}

class L10nFr extends L10n {
  L10nFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mon Application';

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
      {'male': 'Il aime Flutter', 'female': 'Elle aime Flutter', 'other': 'Ils aiment Flutter'},
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
    return 'Dernière mise à jour: ${date}';
  }

  @override
  String timeRemaining(DateTime time) {
    return 'Temps restant: ${time}';
  }
}

class L10nPl extends L10n {
  L10nPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Moja aplikacja';

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
      {'male': 'On lubi Flutter', 'female': 'Ona lubi Flutter', 'other': 'Oni lubią Flutter'},
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
    return 'Ostatnia aktualizacja: ${date}';
  }

  @override
  String timeRemaining(DateTime time) {
    return 'Pozostały czas: ${time}';
  }
}

class L10nSk extends L10n {
  L10nSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'Moja aplikácia';

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
      {'male': 'Má rád Flutter', 'female': 'Má rada Flutter', 'other': 'Majú radi Flutter'},
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
    return 'Naposledy aktualizované: ${date}';
  }

  @override
  String timeRemaining(DateTime time) {
    return 'Zostávajúci čas: ${time}';
  }
}

class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '我的应用程序';

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
      {'male': '他喜欢Flutter', 'female': '她喜欢Flutter', 'other': '他们喜欢Flutter'},
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
    return '最后更新: ${date}';
  }

  @override
  String timeRemaining(DateTime time) {
    return '剩余时间: ${time}';
  }
}

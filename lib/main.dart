import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Localization class to handle multiple languages
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get homeScreenTitle {
    switch (locale.languageCode) {
      case 'en':
        return 'Home Screen';
      case 'ru':
        return 'Главный экран';
      case 'kk':
        return 'Басты экран';
      default:
        return 'Басты экран';
    }
  }

  String get welcomeMessage {
    switch (locale.languageCode) {
      case 'en':
        return 'Welcome to My App';
      case 'ru':
        return 'Добро пожаловать в мое приложение';
      case 'kk':
        return 'Менің қолданбама қош келдіңіз';
      default:
        return 'Менің қолданбама қош келдіңіз';
    }
  }

  String itemTitle(int number) {
    switch (locale.languageCode) {
      case 'en':
        return 'Item $number';
      case 'ru':
        return 'Элемент $number';
      case 'kk':
        return '$number элемент';
      default:
        return '$number элемент';
    }
  }

  String itemDescription(int number) {
    switch (locale.languageCode) {
      case 'en':
        return 'Description of item $number';
      case 'ru':
        return 'Описание элемента $number';
      case 'kk':
        return '$number элементінің сипаттамасы';
      default:
        return '$number элементінің сипаттамасы';
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ru', 'kk'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('kk'); // Default to Kazakh

  void changeTheme(ThemeMode newThemeMode) {
    setState(() {
      _themeMode = newThemeMode;
    });
  }

  void changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter UI Layout',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      locale: _locale, // Use dynamic locale
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
        Locale('kk', ''),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('kk');
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return const Locale('kk');
      },
      home: HomeScreen(
        onThemeChanged: changeTheme,
        currentThemeMode: _themeMode,
        onLocaleChanged: changeLocale,
        currentLocale: _locale,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> itemNumbers = List.generate(20, (index) => index + 1);
  Set<int> expandedItems = {};

  void _toggleTheme() {
    ThemeMode newThemeMode;
    switch (widget.currentThemeMode) {
      case ThemeMode.system:
        newThemeMode = ThemeMode.light;
        break;
      case ThemeMode.light:
        newThemeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newThemeMode = ThemeMode.system;
        break;
    }
    widget.onThemeChanged(newThemeMode);
  }

  void _toggleLocale() {
    Locale newLocale;
    switch (widget.currentLocale.languageCode) {
      case 'en':
        newLocale = const Locale('ru');
        break;
      case 'ru':
        newLocale = const Locale('kk');
        break;
      case 'kk':
        newLocale = const Locale('en');
        break;
      default:
        newLocale = const Locale('en');
    }
    widget.onLocaleChanged(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.homeScreenTitle),
        actions: [
          IconButton(
            icon: Icon(
              widget.currentThemeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : widget.currentThemeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.brightness_auto,
            ),
            onPressed: _toggleTheme,
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: Icon(
              widget.currentLocale.languageCode == 'en'
                  ? Icons.language
                  : widget.currentLocale.languageCode == 'ru'
                      ? Icons.translate
                      : Icons.g_translate,
            ),
            onPressed: _toggleLocale,
            tooltip: 'Change Language',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              localizations.welcomeMessage,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemNumbers.length,
              itemBuilder: (context, index) {
                final itemNumber = itemNumbers[index];
                final isExpanded = expandedItems.contains(itemNumber);
                return Dismissible(
                  key: ValueKey(itemNumber),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      itemNumbers.removeAt(index);
                      expandedItems.remove(itemNumber);
                    });
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.star),
                          title: Text(localizations.itemTitle(itemNumber)),
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                expandedItems.remove(itemNumber);
                              } else {
                                expandedItems.add(itemNumber);
                              }
                            });
                          },
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:
                                Text(localizations.itemDescription(itemNumber)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            final newItemNumber =
                itemNumbers.isEmpty ? 1 : itemNumbers.last + 1;
            itemNumbers.add(newItemNumber);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Новая строка


import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'services/app_localization.dart';
import 'services/auth_service.dart'; // Новая строка

import 'package:flutter/foundation.dart' show kIsWeb; // добавляем
import 'firebase_options.dart'; // добавляем (файл с настройками)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('kk');

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
    return ChangeNotifierProvider(
      create: (_) => AuthService(), // Провайдер авторизации
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Navigation Demo',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: _themeMode,
            locale: _locale,
            localizationsDelegates: const [
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
            initialRoute: '/',
            routes: {
              '/': (context) => HomeScreen(
                    onThemeChanged: changeTheme,
                    currentThemeMode: _themeMode,
                    onLocaleChanged: changeLocale,
                    currentLocale: _locale,
                  ),
              '/about': (context) => AboutScreen(currentLocale: _locale),
              '/settings': (context) => SettingsScreen(
                    onThemeChanged: changeTheme,
                    currentThemeMode: _themeMode,
                    onLocaleChanged: changeLocale,
                    currentLocale: _locale,
                  ),
              '/login': (context) => const LoginScreen(), // ← добавляем это
              '/profile': (context) => ProfileScreen(
                    onThemeChanged: changeTheme,
                    currentThemeMode: _themeMode,
                    onLocaleChanged: changeLocale,
                    currentLocale: _locale,
              ),

            },
          );
        },
      ),
    );
  }
}

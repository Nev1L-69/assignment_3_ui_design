import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/task.dart';
import 'models/user_profile.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/task_provider.dart';
import 'services/local_storage_service.dart';
import 'services/firebase_service.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/history_screen.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, theme, locale, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Daily Planner',
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.deepPurple,
                secondary: Colors.deepPurpleAccent,
                background: Colors.white.withOpacity(0.95),
              ),
              scaffoldBackgroundColor: Colors.white.withOpacity(0.95),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white.withOpacity(0.92),
                foregroundColor: Colors.deepPurple,
                elevation: 0,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white.withOpacity(0.88),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              cardColor: Colors.white.withOpacity(0.95),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.deepPurple, fontSize: 17),
                bodyMedium: TextStyle(color: Colors.deepPurple),
              ),
            ),
            darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                secondary: Colors.purpleAccent,
                background: Colors.black.withOpacity(0.94),
              ),
              scaffoldBackgroundColor: Colors.black.withOpacity(0.94),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.black.withOpacity(0.9),
                foregroundColor: Colors.deepPurple,
                elevation: 0,
              ),
              cardColor: Colors.grey[900],
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.deepPurple,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white, fontSize: 17),
                bodyMedium: TextStyle(color: Colors.white),
              ),
            ),
            themeMode: theme.themeMode,
            locale: locale.locale,
            supportedLocales: L10n.supportedLocales,
            localizationsDelegates: L10n.localizationsDelegates,
            localeResolutionCallback: L10n.localeResolutionCallback,
            initialRoute: '/',
            routes: {
              '/': (_) => const SplashScreen(),
              '/home': (_) => const HomeScreen(),
              '/about': (_) => const AboutScreen(),
              '/settings': (_) => const SettingsScreen(),
              '/profile': (_) => const ProfileScreen(),
              '/auth': (_) => const AuthScreen(),
              '/history': (_) => const HistoryScreen(),
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:nhost_flutter_auth/nhost_flutter_auth.dart';
import 'providers/data_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main_screen.dart';
import 'screens/auth_screen.dart';
import 'services/nhost_service.dart';
import 'l10n/app_localizations.dart';

void main() {
  NhostService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NhostAuthProvider(
      auth: NhostService().client.auth,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DataProvider()..loadData()),
          ChangeNotifierProvider(
            create: (_) => LanguageProvider()..loadLanguage(),
          ),
          ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
        ],
        child: Consumer2<LanguageProvider, ThemeProvider>(
          builder: (context, languageProvider, themeProvider, child) {
            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).appTitle,
              debugShowCheckedModeBanner: false,
              locale: languageProvider.locale,
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('my'), // Myanmar
              ],
              themeMode: themeProvider.themeMode,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFFFACC15), // Yellow base
                  primary: const Color(
                    0xFFFACC15,
                  ), // Exact yellow for buttons/accents
                ),
                useMaterial3: true,
                fontFamily: 'Inter',
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: ZoomPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  },
                ),
                appBarTheme: const AppBarTheme(
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  titleTextStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  iconTheme: IconThemeData(color: Colors.black87),
                ),
                cardTheme: CardThemeData(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFFFACC15),
                  primary: const Color(0xFFFACC15),
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
                fontFamily: 'Inter',
                scaffoldBackgroundColor: const Color(0xFF121212),
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: ZoomPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  },
                ),
                appBarTheme: const AppBarTheme(
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Color(0xFF1E1E1E),
                  surfaceTintColor: Colors.transparent,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                cardTheme: CardThemeData(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color(0xFF1E1E1E),
                  surfaceTintColor: const Color(0xFF1E1E1E),
                ),
              ),
              home: const AuthGate(),
            );
          },
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = NhostAuthProvider.of(context);

    if (auth == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Check if the user is authenticated
    if (auth.authenticationState == AuthenticationState.signedIn) {
      return const MainScreen();
    }

    return const AuthScreen();
  }
}

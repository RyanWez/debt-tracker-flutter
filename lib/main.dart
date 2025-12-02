import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/data_provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()..loadData()),
      ],
      child: MaterialApp(
        title: 'Debt Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFACC15), // Yellow
            primary: const Color(0xFFFACC15),
            secondary: const Color(0xFF10B981), // Green
            error: const Color(0xFFEF4444), // Red
            surface: const Color(0xFFF8FAFC), // Light Grey Surface
            background: Colors.white,
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
        home: const MainScreen(),
      ),
    );
  }
}

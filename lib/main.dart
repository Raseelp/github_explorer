import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/initial_binding.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GitHub Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2F6FED),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F6FA),
          elevation: 0,
          foregroundColor: Colors.black87,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2F6FED),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialBinding: InitialBinding(),
      home: const SearchScreen(),
    );
  }
}

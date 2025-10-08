import 'package:flutter/material.dart';

import 'package:go_dino/ui/screens/base_screen.dart';
import 'package:go_dino/ui/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Dino!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightBackground,
        primaryColor: AppColors.darkGreen,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: AppColors.lightBackground,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.leafGreen,
            foregroundColor: AppColors.lightBackground,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.darkGreen),
          bodyMedium: TextStyle(color: AppColors.oliveBrown),
          labelSmall: TextStyle(color: AppColors.softGold),
        ),
      ),

      home: const BaseScreen(title: "Go Dino!"),
    );
  }
}
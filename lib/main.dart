import 'package:expense_tracker_app/features/btm_navbar/btm_navbar.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      ),
      home: BtmNavbar(),
    );
  }
}

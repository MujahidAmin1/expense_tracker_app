import 'package:expense_tracker_app/features/btm_navbar/btm_navbar.dart';
import 'package:expense_tracker_app/features/budgets/service/budget_service.dart';
import 'package:expense_tracker_app/features/transaction/service/transaction_service.dart';
import 'package:expense_tracker_app/features/liveness check/liveness_check_view.dart';
import 'package:expense_tracker_app/hive_registrar.g.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  
  try {
    await TransactionService.init();
    await BudgetService.init();
  } catch (e) {
    debugPrint('Hive corrupted, wiping data: $e');
    await Hive.deleteFromDisk();
    await TransactionService.init();
    await BudgetService.init();
  }

  runApp(
    ProviderScope(
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
      ),
      home: BtmNavbar(),
    );
  }
}

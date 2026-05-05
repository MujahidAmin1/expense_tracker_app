import 'package:expense_tracker_app/features/navbar/navbar.dart';
import 'package:expense_tracker_app/features/budgets/service/budget_service.dart';
import 'package:expense_tracker_app/features/transaction/service/transaction_service.dart';
import 'package:expense_tracker_app/features/liveness check/liveness_check_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:expense_tracker_app/hive_registrar.g.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:expense_tracker_app/features/navbar/nav_ctrl.dart';
import 'package:expense_tracker_app/features/transaction/view/add_transaction.dart';
import 'package:expense_tracker_app/utils/navigator_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
    await TransactionService.init();
    await BudgetService.init();
  runApp(
    ProviderScope(
      child: const MainApp(),
    ),
  );
}




class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDesktopOrWeb = kIsWeb || (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
         useMaterial3: true,
      ),
      home: isDesktopOrWeb ? Builder(
        builder: (context) => CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.keyN, control: true): () => context.push(const AddTransactionScreen()),
            const SingleActivator(LogicalKeyboardKey.digit1, control: true): () => navigateTo(ref, 0),
            const SingleActivator(LogicalKeyboardKey.digit2, control: true): () => navigateTo(ref, 1),
            const SingleActivator(LogicalKeyboardKey.digit3, control: true): () => navigateTo(ref, 2),
            const SingleActivator(LogicalKeyboardKey.digit4, control: true): () => navigateTo(ref, 3),
          },
          child: Focus(
            autofocus: true,
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!kIsWeb) ...[
                    MenuBar(
                      style: MenuStyle(
                        backgroundColor: WidgetStateProperty.all(AppColors.white),
                        elevation: WidgetStateProperty.all(0),
                      ),
                      children: <Widget>[
                        SubmenuButton(
                          menuChildren: <Widget>[
                            MenuItemButton(
                              onPressed: () => context.push(const AddTransactionScreen()),
                              shortcut: const SingleActivator(LogicalKeyboardKey.keyN, control: true),
                              child: const Text('New Transaction'),
                            ),
                          ],
                          child: const Text('File', style: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold)),
                        ),
                        SubmenuButton(
                          menuChildren: <Widget>[
                            MenuItemButton(
                              onPressed: () {},
                              shortcut: const SingleActivator(LogicalKeyboardKey.keyZ, control: true),
                              child: const Text('Undo'),
                            ),
                          ],
                          child: const Text('Edit', style: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold)),
                        ),
                        SubmenuButton(
                          menuChildren: <Widget>[
                            MenuItemButton(
                              onPressed: () => navigateTo(ref, 0),
                              shortcut: const SingleActivator(LogicalKeyboardKey.digit1, control: true),
                              child: const Text('Dashboard'),
                            ),
                            MenuItemButton(
                              onPressed: () => navigateTo(ref, 1),
                              shortcut: const SingleActivator(LogicalKeyboardKey.digit2, control: true),
                              child: const Text('Budgets'),
                            ),
                            MenuItemButton(
                              onPressed: () => navigateTo(ref, 2),
                              shortcut: const SingleActivator(LogicalKeyboardKey.digit3, control: true),
                              child: const Text('Insights'),
                            ),
                            MenuItemButton(
                              onPressed: () => navigateTo(ref, 3),
                              shortcut: const SingleActivator(LogicalKeyboardKey.digit4, control: true),
                              child: const Text('Settings'),
                            ),
                          ],
                          child: const Text('View', style: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold)),
                        ),
                        SubmenuButton(
                          menuChildren: <Widget>[
                            MenuItemButton(
                              onPressed: () {},
                              child: const Text('About'),
                            ),
                          ],
                          child: const Text('Help', style: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const Divider(height: 1, thickness: 1, color: AppColors.dividerColor),
                  ],
                  const Expanded(child: Navbar()),
                ],
              ),
            ),
          ),
        ),
      ) : const LivenessCheckView(),
    );
  }
}

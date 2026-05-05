import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final currentScreenProvider = StateProvider.autoDispose<int?>((ref) => 0);

void navigateTo(WidgetRef ref, int screen) {
  final current = ref.read(currentScreenProvider);

  if (screen != current) {
    ref.read(currentScreenProvider.notifier).state = screen;
  }
}
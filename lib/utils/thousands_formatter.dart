import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatter {
  static final _number = NumberFormat('#,###.##');

  static String number(num value) => _number.format(value);

  static String currency(num value, {int decimalDigits = 2}) {
    final format = NumberFormat.currency(
      locale: 'en_US',
      symbol: "\$",
      decimalDigits: decimalDigits,
    );
    return format.format(value);
  }
}

class ThousandsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Allow just a dot
    if (newValue.text == '.') {
      return const TextEditingValue(
        text: '0.',
        selection: TextSelection.collapsed(offset: 2),
      );
    }

    String text = newValue.text;
    text = text.replaceAll(',', '');

    // Check if it's a valid number with optional decimal
    final regEx = RegExp(r'^\d*\.?\d*$');
    if (!regEx.hasMatch(text)) {
      return oldValue;
    }

    // Split parts
    List<String> parts = text.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    if (integerPart.isEmpty) integerPart = '0';

    final formatter = NumberFormat('#,###');
    String newText = formatter.format(int.parse(integerPart)) + decimalPart;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
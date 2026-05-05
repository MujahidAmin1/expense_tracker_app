import 'package:flutter/material.dart';

extension ResponsiveX on BuildContext {
  bool get isDesktop => MediaQuery.sizeOf(this).width >= 900;
  bool get isTablet => MediaQuery.sizeOf(this).width >= 600;
  bool get isMobile => MediaQuery.sizeOf(this).width < 600;
}
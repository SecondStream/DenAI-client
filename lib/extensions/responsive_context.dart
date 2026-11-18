import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isMobile => !isDesktop;
  bool get isDesktop => screenWidth >= 550;
}

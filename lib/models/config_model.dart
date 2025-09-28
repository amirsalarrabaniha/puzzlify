import 'dart:ui';

import 'package:flutter/cupertino.dart';

class PuzzlifyConfig {
  final Color borderSelectColor;
  final BorderRadius borderRadius;
  final double borderSelectWidth;
  final double verticalSpace;
  final double horizontalSpace;

  PuzzlifyConfig({
    required this.borderSelectColor,
    required this.borderRadius,
    this.borderSelectWidth = 2,
    this.verticalSpace = 5,
    this.horizontalSpace = 5,
  });
}

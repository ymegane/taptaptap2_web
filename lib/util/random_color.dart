import 'dart:math';
import 'package:flutter_web_ui/ui.dart';

import 'package:flutter_web/material.dart';

final Random _random = Random.secure();

Color get() {
  final int length = Colors.primaries.length;
  return Colors.primaries[_random.nextInt(length)].withAlpha(200);
}

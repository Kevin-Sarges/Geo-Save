import 'dart:async';

import 'package:flutter/material.dart';

class DebouncerHelpers {
  Timer? timer;

  DebouncerHelpers();

  void call(VoidCallback run) {
    timer?.cancel();

    timer = Timer(const Duration(seconds: 1), run);
  }
}

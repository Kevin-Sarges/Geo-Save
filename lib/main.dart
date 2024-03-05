import 'package:flutter/material.dart';
import 'package:geosave/app/common/inject/inject_dependecy.dart';
import 'package:geosave/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  InjectDependecy.init();
  runApp(const MyApp());
}

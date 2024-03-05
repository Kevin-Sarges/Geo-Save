import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geosave/app/common/colors/colors_app.dart';
import 'package:geosave/app/common/routes/app_routes.dart';
import 'package:geosave/app/features/list_local/presenter/list_local_screen.dart';
import 'package:geosave/app/features/map/presenter/map_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geo Save',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarColor: ColorsApp.white100,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
      ),
      routes: {
        AppRoutes.map: (context) => const MapScreen(),
        AppRoutes.list: (context) => const ListLocalScreen(),
      },
    );
  }
}

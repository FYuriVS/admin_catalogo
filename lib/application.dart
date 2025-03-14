import 'package:admin_catalogo/core/routing/router.dart';
import 'package:admin_catalogo/core/ui/resources/fonts.dart';
import 'package:admin_catalogo/core/ui/resources/theme.dart';
import 'package:admin_catalogo/core/ui/resources/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

GetIt getIt = GetIt.instance;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final ThemeNotifier _themeNotifier = getIt.get(instanceName: 'theme');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateThemeFromSystem();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _updateThemeFromSystem();
  }

  void _updateThemeFromSystem() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _themeNotifier.value =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeNotifier,
        builder: (context, themeMode, _) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            themeMode: themeMode,
            theme: theme.light(),
            darkTheme: theme.dark(),
            debugShowCheckedModeBanner: false,
            routerConfig: routerConfig(),
          );
        });
  }
}

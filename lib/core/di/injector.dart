import 'package:admin_catalogo/core/ui/resources/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

void injector() {
  var i = GetIt.instance;
  i.registerSingleton<Client>(http.Client());
  i.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  i.registerSingleton<ThemeNotifier>(ThemeNotifier(ThemeMode.light),
      instanceName: 'theme');
}

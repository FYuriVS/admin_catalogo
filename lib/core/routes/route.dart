import 'package:admin_catalogo/app_widget.dart';
import 'package:admin_catalogo/core/routes/routes.dart';
import 'package:admin_catalogo/features/handle-product/presentation/screens/register_product_screen.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  Routes.app: (context) => const AppWidget(),
  Routes.registerProduct: (context) => const RegisterProductScreen(),
  // Routes.splashScreen: (context) => const SplashScreen(),
  // Routes.signIn: (context) => const SignInScreen(),
};

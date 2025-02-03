import 'package:admin_catalogo/features/handle-product/presentation/screens/list_product_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  // int _currentIndex = 0;

  // static const List<Widget> _bottomNavigationPages = [Page1(), Page2()];

  // void _onTabSelected(int index) {
  //   if (index != _currentIndex) {
  //     setState(() {
  //       _currentIndex = index;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.secondaryContainer,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Material(
      child: ListProductScreen(),
    );
  }
}

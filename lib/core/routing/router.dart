import 'package:admin_catalogo/core/routing/routes.dart';
import 'package:admin_catalogo/features/handle-product/presentation/screens/products_screen.dart';
import 'package:admin_catalogo/features/handle-product/presentation/screens/register_product_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter routerConfig() {
  return GoRouter(
    initialLocation: Routes.listProducts,
    routes: [
      GoRoute(
        path: Routes.listProducts,
        builder: (context, state) => ProductsScreen(),
      ),
      GoRoute(
        path: Routes.registerProduct,
        builder: (context, state) => RegisterProductScreen(),
      ),
    ],
  );
}

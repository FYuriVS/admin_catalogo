import 'package:admin_catalogo/features/handle-product/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> listProducts();
  Future<void> deleteProduct(String prdocutId);
}

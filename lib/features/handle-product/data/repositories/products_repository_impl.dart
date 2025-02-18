import 'package:admin_catalogo/features/handle-product/data/datasources/products_remote_data_source.dart';
import 'package:admin_catalogo/features/handle-product/domain/entities/product.dart';
import 'package:admin_catalogo/features/handle-product/domain/repository/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource dataSource;

  ProductsRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<Product>> listProducts() async {
    return await dataSource.listProduct();
  }

  @override
  Future<void> deleteProduct(String productId) async {
    return await dataSource.deleteProduct(productId);
  }
}

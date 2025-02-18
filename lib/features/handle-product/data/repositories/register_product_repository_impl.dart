import 'package:admin_catalogo/features/handle-product/data/datasources/register_product_remote_data_source.dart';
import 'package:admin_catalogo/features/handle-product/data/entities/register_product_request.dart';
import 'package:admin_catalogo/features/handle-product/domain/repository/register_product_repository.dart';

class RegisterProductRepositoryImpl implements RegisterProductRepository {
  final RegisterProductRemoteDataSource datasource;

  RegisterProductRepositoryImpl({required this.datasource});

  @override
  Future<String> registerProduct(RegisterProductRequest request) async {
    return await datasource.registerProduct(request);
  }
}

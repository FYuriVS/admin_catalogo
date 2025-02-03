import 'dart:io';

import 'package:admin_catalogo/features/handle-product/data/entities/register_product_request.dart';

abstract class RegisterProductRepository {
  Future<String> registerProduct(RegisterProductRequest request);
  Future<String> uploadImages(List<File> images);
}

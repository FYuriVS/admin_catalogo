import 'package:admin_catalogo/core/commands/commands.dart';
import 'package:admin_catalogo/core/result/result.dart';
import 'package:admin_catalogo/features/handle-product/domain/entities/product.dart';
import 'package:admin_catalogo/features/handle-product/domain/repository/products_repository.dart';
import 'package:flutter/material.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductsRepository productsRepository;
  late Command0 listProducts;

  ProductsViewModel({
    required this.productsRepository,
  }) {
    listProducts = Command0<List<Product>>(_listProducts)..execute();
  }

  List<Product> _products = [];

  List<Product> get products => _products;

  Future<Result<List<Product>>> _listProducts() async {
    try {
      notifyListeners();
      final response = await productsRepository.listProducts();
      if (response.isEmpty) {
        return Result.ok([]);
      }
      notifyListeners();
      _products = response;
      return Result.ok(response);
    } catch (e) {
      notifyListeners();
      return Result.error(
        Exception(e.toString()),
      );
    }
  }
}

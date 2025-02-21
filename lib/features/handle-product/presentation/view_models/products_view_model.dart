import 'package:admin_catalogo/core/commands/commands.dart';
import 'package:admin_catalogo/core/result/result.dart';
import 'package:admin_catalogo/features/handle-product/domain/entities/product.dart';
import 'package:admin_catalogo/features/handle-product/domain/repository/products_repository.dart';
import 'package:flutter/material.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductsRepository productsRepository;
  late Command0 listProducts;
  late Command1 deleteProduct;

  ProductsViewModel({
    required this.productsRepository,
  }) {
    listProducts = Command0<List<Product>>(_listProducts);
    deleteProduct = Command1<String, String>(_deleteProduct);
  }

  List<Product> _products = [];

  List<Product> get products => _products;

  Future<Result<List<Product>>> _listProducts() async {
    try {
      final response = await productsRepository.listProducts();
      _products = response; // Atualiza a lista antes do notifyListeners()
      notifyListeners();
      return Result.ok(response);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<String>> _deleteProduct(String productId) async {
    try {
      await productsRepository.deleteProduct(productId);
      await _listProducts(); // Recarrega a lista de produtos após a exclusão
      return Result.ok("Produto deletado");
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}

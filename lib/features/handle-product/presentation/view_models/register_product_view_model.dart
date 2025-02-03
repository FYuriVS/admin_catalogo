import 'package:admin_catalogo/core/commands/commands.dart';
import 'package:admin_catalogo/core/result/result.dart';
import 'package:admin_catalogo/features/handle-product/data/entities/register_product_request.dart';
import 'package:admin_catalogo/features/handle-product/domain/repository/register_product_repository.dart';
import 'package:flutter/material.dart';

class RegisterProductViewModel extends ChangeNotifier {
  final RegisterProductRepository registerProductRepository;
  late Command1 registerProduct;

  RegisterProductViewModel(this.registerProductRepository) {
    registerProduct =
        Command1<String, RegisterProductRequest>(_registerProduct);
  }

  Future<Result<String>> _registerProduct(
      RegisterProductRequest request) async {
    if (request.name.isEmpty || request.description.isEmpty) {
      return Result.error(
          Exception("Preencha todos os campos para efetuar o login"));
    }

    try {
      final response = await registerProductRepository.registerProduct(request);
      if (response.isEmpty) {
        return Result.ok("");
      }

      return Result.ok("Registrado com sucesso!");
    } catch (e) {
      return Result.error(
        Exception(e.toString()),
      );
    }
  }
}

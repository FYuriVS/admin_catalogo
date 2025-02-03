import 'dart:io';
import 'package:admin_catalogo/features/handle-product/data/entities/register_product_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterProductRemoteDataSource {
  RegisterProductRemoteDataSource();

  Future<String> registerProduct(RegisterProductRequest request) async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .insert({'name': request.name, 'description': request.description})
          .select()
          .single();

      final productId = response['id'];

      if (response.isNotEmpty) {
        await uploadImages(productId, request.selectedImages);
        return productId; // Retorna o ID do produto criado
      } else {
        throw Exception('Falha ao cadastrar o produto');
      }
    } catch (e) {
      return Future.error("Erro ao cadastrar produto: $e");
    }
  }

  Future<String> uploadImages(
      String productId, List<File> selectedImages) async {
    if (selectedImages.isEmpty) return "Nenhuma imagem selecionada.";

    List<String> imageUrls = [];

    for (var image in selectedImages) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      final path = 'uploads/$fileName';

      try {
        final fileBytes = await image.readAsBytes(); // Lê o arquivo como bytes
        await Supabase.instance.client.storage
            .from('images')
            .uploadBinary(path, fileBytes);

        final imageUrl =
            Supabase.instance.client.storage.from('images').getPublicUrl(path);
        imageUrls.add(imageUrl);
      } catch (e) {
        return "Erro ao fazer upload da imagem: $e";
      }
    }

    if (imageUrls.isNotEmpty) {
      await Supabase.instance.client.from('product_images').insert(imageUrls
          .map((url) => {'product_id': productId, 'image_url': url})
          .toList());

      return "Upload concluído com sucesso.";
    }

    return "Nenhuma imagem foi enviada."; // Garante um retorno em todos os cenários
  }
}

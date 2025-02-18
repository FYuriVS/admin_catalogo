import 'package:admin_catalogo/application.dart';
import 'package:admin_catalogo/features/handle-product/domain/entities/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsRemoteDataSource {
  final SupabaseClient supabaseClient = getIt.get<SupabaseClient>();
  Future<List<Product>> listProduct() async {
    final response = await supabaseClient
        .from('products')
        .select('id, name, description, product_images(image_url)')
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Product(
              id: json['id'] as String,
              name: json['name'] as String,
              description: json['description'] as String,
              urlImages: (json['product_images'] as List<dynamic>)
                  .map((image) => image['image_url'] as String)
                  .toList(),
            ))
        .toList();
  }

  Future<void> deleteProduct(String productId) async {
    final bucketName = 'images';
    final images = await supabaseClient
        .from('product_images')
        .select('image_url')
        .eq('product_id', productId);

    if (images.isNotEmpty) {
      List<String> filePaths = [];

      for (var image in images) {
        String imageUrl = image['image_url'];

        Uri uri = Uri.parse(imageUrl);
        String path = uri.pathSegments.sublist(5).join('/');
        filePaths.add(path);
      }

      if (filePaths.isNotEmpty) {
        await supabaseClient.storage.from(bucketName).remove(filePaths);
      }
    }
    await supabaseClient
        .from('product_images')
        .delete()
        .eq('product_id', productId);
    await supabaseClient.from('products').delete().eq('id', productId);
  }
}

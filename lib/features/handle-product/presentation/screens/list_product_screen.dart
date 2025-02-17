import 'package:admin_catalogo/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  final _supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = fetchProducts();
    });
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await _supabase
        .from('products')
        .select('id, name, description, product_images(image_url)')
        .order('created_at', ascending: false);

    return response;
  }

  Future<void> deleteProduct(String productId) async {
    final bucketName = 'images';
    final images = await _supabase
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
        await _supabase.storage.from(bucketName).remove(filePaths);
      }
    }
    await _supabase.from('product_images').delete().eq('product_id', productId);
    await _supabase.from('products').delete().eq('id', productId);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
        notificationPredicate: (notification) => false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar produtos"));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text("Nenhum produto encontrado"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cards por linha
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8, // Ajuste conforme necessário
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final images = product['product_images'] as List?;
              final imageUrl = images != null && images.isNotEmpty
                  ? images.first['image_url']
                  : null;

              return GestureDetector(
                onLongPress: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Excluir Produto"),
                      content: const Text(
                          "Tem certeza de que deseja excluir este produto?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Excluir"),
                        ),
                      ],
                    ),
                  );
                  if (shouldDelete == true) {
                    await deleteProduct(product['id']);
                  }
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: imageUrl != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.image_not_supported, size: 50),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product['description'] ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, Routes.registerProduct);
          _loadProducts(); // Recarrega a lista ao voltar da tela de cadastro
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

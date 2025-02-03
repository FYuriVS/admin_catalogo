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
    // Deletar o produto da tabela 'products'
    final response =
        await _supabase.from('products').delete().eq('id', productId);

    if (response != null) {
      // Tratar erro de exclusão
      if (response!.error != null) {
        return;
      }
    }

    // Deletar as imagens associadas ao produto na tabela 'product_images'
    final imagesResponse = await _supabase
        .from('product_images')
        .delete()
        .eq('product_id', productId);

    if (imagesResponse != null) {
      // Tratar erro de exclusão
      if (imagesResponse.error != null) {
        // Tratar erro de exclusão das imagens
        return;
      }
    }

    // Recarregar os produtos após a exclusão
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produtos")),
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

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final images = product['product_images'] as List?;
              final imageUrl = images != null && images.isNotEmpty
                  ? images.first['image_url']
                  : null;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: imageUrl != null
                      ? Image.network(imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(product['name']),
                  subtitle: Text(product['description'] ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Confirmar a exclusão antes de realizar a operação
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
                  ),
                  onTap: () {
                    // Aqui você pode abrir uma tela de detalhes do produto
                  },
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

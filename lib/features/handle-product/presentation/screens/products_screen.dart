import 'package:admin_catalogo/application.dart';
import 'package:admin_catalogo/core/routing/routes.dart';
import 'package:admin_catalogo/features/handle-product/domain/entities/product.dart';
import 'package:admin_catalogo/features/handle-product/presentation/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final viewModel = getIt.get<ProductsViewModel>();

  Future<List<Product>> fetchProducts() async {
    await viewModel.listProducts.execute();
    return viewModel.products;
  }

  Future<void> deleteProduct(String productId) async {
    await viewModel.deleteProduct.execute(productId);
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
        notificationPredicate: (notification) => false,
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.listProducts.running) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (viewModel.products.isEmpty) {
            return Center(
              child: Text("Nenhum produto registrado"),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards por linha
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8, // Ajuste conforme necessário
              ),
              itemCount: viewModel.products.length,
              itemBuilder: (context, index) {
                final product = viewModel.products[index];
                final images = product.urlImages as List?;
                final imageUrl =
                    images != null && images.isNotEmpty ? images.first : null;

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
                      await deleteProduct(product.id);
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
                                  product.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.description,
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
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(Routes.registerProduct);
          if (result == true) {
            await viewModel.listProducts.execute();
          }
        },
        backgroundColor: Colors.redAccent.shade100,
        child: Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }
}

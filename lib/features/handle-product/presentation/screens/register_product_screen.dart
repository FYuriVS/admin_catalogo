import 'dart:io';
import 'package:admin_catalogo/utils/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({super.key});

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  List<File> selectedImages = [];
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImages.add(File(image.path));
      });
    }
  }

  void deleteSelectedImage(File image) {
    setState(() {
      selectedImages.remove(image);
    });
  }

  Future<void> registerProduct() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client
          .from('products')
          .insert({
            'name': _nameController.text,
            'description': _descriptionController.text
          })
          .select()
          .single();

      final productId = response['id'];

      await uploadImages(productId);

      // Limpar os campos após o cadastro
      _nameController.clear();
      _descriptionController.clear();
      setState(() {
        selectedImages.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar produto")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> uploadImages(String productId) async {
    if (selectedImages.isEmpty) return;

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
        print("Erro ao fazer upload da imagem: $e");
      }
    }

    if (imageUrls.isNotEmpty) {
      await Supabase.instance.client.from('product_images').insert(imageUrls
          .map((url) => {'product_id': productId, 'image_url': url})
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              selectedImages.isNotEmpty
                  ? SizedBox(
                      height: size.height * 0.3,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          final image = selectedImages[index];
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                width: size.width * 0.9,
                                height: size.height * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(image, fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  onPressed: () => deleteSelectedImage(image),
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : Container(
                      width: size.width * 0.9,
                      height: size.height * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                      child: Center(child: Text("Nenhuma imagem selecionada")),
                    ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Adicionar foto"),
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _nameController,
                label: "Nome do produto",
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: "Descrição do produto",
              ),
              SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: registerProduct,
                      child: Text("Salvar Produto"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

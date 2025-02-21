import 'dart:io';
import 'package:admin_catalogo/application.dart';
import 'package:admin_catalogo/features/handle-product/data/entities/register_product_request.dart';
import 'package:admin_catalogo/features/handle-product/presentation/view_models/register_product_view_model.dart';
import 'package:admin_catalogo/utils/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({super.key});

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  List<File> selectedImages = [];
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final viewModel = getIt.get<RegisterProductViewModel>();
  final _formKey = GlobalKey<FormState>();

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
      _showMessage("Preencha todos os campos");
      return;
    }

    await viewModel.registerProduct.execute(
      RegisterProductRequest(
        name: _nameController.text,
        description: _descriptionController.text,
        selectedImages: selectedImages,
      ),
    );

    if (viewModel.registerProduct.completed) {
      _nameController.clear();
      _descriptionController.clear();
      selectedImages.clear();
      _showMessage("Produto adicionado");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Cadastrar Produto"),
            notificationPredicate: (notification) => false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16.0,
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
                                      child:
                                          Image.file(image, fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      onPressed: () =>
                                          deleteSelectedImage(image),
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
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
                            color:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ),
                          child:
                              Center(child: Text("Nenhuma imagem selecionada")),
                        ),
                  Column(
                    spacing: 16.0,
                    children: [
                      Material(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: pickImage,
                          borderRadius: BorderRadius.circular(16),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              height: 52,
                              child: Center(
                                child: Text("Adicionar Foto"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 16),
                      CustomTextField(
                        controller: _nameController,
                        label: "Nome do produto",
                      ),
                      // SizedBox(height: 16),
                      CustomTextField(
                        controller: _descriptionController,
                        label: "Descrição do produto",
                      ),
                      // SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.red,
            height: 50,
            child: Material(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: InkWell(
                onTap: registerProduct,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 52,
                    child: Center(
                      child: viewModel.registerProduct.running
                          ? CircularProgressIndicator()
                          : Text("Salvar Produto"),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

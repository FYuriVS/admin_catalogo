import 'dart:io';

class RegisterProductRequest {
  final String name;
  final String description;
  final List<File> selectedImages;

  const RegisterProductRequest({
    required this.name,
    required this.description,
    required this.selectedImages,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'selectedImages': selectedImages,
    };
  }

  factory RegisterProductRequest.fromMap(Map<String, dynamic> map) {
    return RegisterProductRequest(
        name: map['name'] as String,
        description: map['description'] as String,
        selectedImages: map['selectedImages'] as List<File>);
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final List<String> urlImages;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.urlImages,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      urlImages: List<String>.from(json['url_images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url_images': urlImages,
    };
  }
}

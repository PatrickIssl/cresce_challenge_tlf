class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int ratingCount;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? 'Produto sem nome',
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'] ?? 'Sem descrição disponível',
      category: json['category'] ?? 'Sem categoria',
      imageUrl: json['image'] ?? '',
      rating: (json['rating'] != null) ? (json['rating']['rate'] ?? 0.0).toDouble() : 0.0,
      ratingCount: (json['rating'] != null) ? (json['rating']['count'] ?? 0) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': imageUrl,
      'rating': {
        'rate': rating,
        'count': ratingCount,
      },
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

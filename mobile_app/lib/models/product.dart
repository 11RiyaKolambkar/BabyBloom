class Product {
  final String id;
  final String name;
  final String desc;
  final double price;
  final int stock;
  final List<String> images;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.stock,
    required this.images,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> parsedImages = [];
    if (json['img'] != null && json['img'] is List) {
      parsedImages = List<String>.from(json['img'].map((x) => x.toString()));
    } else if (json['img'] != null && json['img'] is String) {
      parsedImages = [json['img'].toString()];
    }

    return Product(
      id: json['_id']?.toString() ?? '',
      name: json['p_name']?.toString() ?? 'Unnamed Product',
      desc: json['desc']?.toString() ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      stock: (json['stock'] is num) ? (json['stock'] as num).toInt() : 0,
      images: parsedImages,
      category: json['category']?.toString() ?? 'General',
    );
  }

  String get primaryImage => images.isNotEmpty ? images.first : '';
}

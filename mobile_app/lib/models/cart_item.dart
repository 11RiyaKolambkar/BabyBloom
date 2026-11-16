class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int qty;
  final String? image;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.qty,
    this.image,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    String? img;
    if (json['img'] != null && json['img'] is List && (json['img'] as List).isNotEmpty) {
      img = json['img'][0].toString();
    } else if (json['img'] != null && json['img'] is String) {
      img = json['img'].toString();
    }

    return CartItem(
      id: json['_id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productName: json['p_name']?.toString() ?? 'Product',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      qty: (json['qty'] is num) ? (json['qty'] as num).toInt() : 1,
      image: img,
    );
  }

  double get subtotal => price * qty;
}

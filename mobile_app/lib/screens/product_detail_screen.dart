import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../constants.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isLoading = true;
  int _quantity = 1;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() => _isLoading = true);
    final p = await ApiService.getProductDetails(widget.productId);
    setState(() {
      _product = p;
      _isLoading = false;
    });
  }

  Future<void> _addToCart({bool navigateToCart = false}) async {
    if (_product == null) return;

    setState(() => _isAdding = true);
    final res = await ApiService.addToCart(_product!.id, _quantity);
    setState(() => _isAdding = false);

    if (!mounted) return;

    if (res['success'] == true) {
      if (navigateToCart) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $_quantity of ${_product!.name} to cart!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'GO TO CART',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Failed to add item'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: const Center(child: Text('Product not found')),
      );
    }

    final imageUrl = AppConfig.getImageUrl(_product!.primaryImage);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_product!.name),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Product Image
            Container(
              height: 280,
              width: double.infinity,
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.all(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Center(
                  child: Icon(Icons.image_not_supported_outlined,
                      size: 64, color: Colors.grey),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _product!.category,
                      style: const TextStyle(
                        color: Color(0xFF0369A1),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Product Title
                  Text(
                    _product!.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price & Stock
                  Row(
                    children: [
                      Text(
                        '₹${_product!.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _product!.stock > 0
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _product!.stock > 0
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                          ),
                        ),
                        child: Text(
                          _product!.stock > 0
                              ? 'In Stock (${_product!.stock} available)'
                              : 'Out of Stock',
                          style: TextStyle(
                            color: _product!.stock > 0 ? Colors.green.shade800 : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Description
                  const Text(
                    'Product Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _product!.desc,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  Row(
                    children: [
                      const Text(
                        'Quantity:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: _quantity < _product!.stock
                                  ? () => setState(() => _quantity++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _isAdding || _product!.stock <= 0
                    ? null
                    : () => _addToCart(navigateToCart: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBBF24),
                  foregroundColor: const Color(0xFF78350F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isAdding || _product!.stock <= 0
                    ? null
                    : () => _addToCart(navigateToCart: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

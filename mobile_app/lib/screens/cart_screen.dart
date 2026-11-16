import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';
import '../constants.dart';
import 'login_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _items = [];
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    final loggedIn = await ApiService.isLoggedIn();
    if (!loggedIn) {
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
      return;
    }

    _isLoggedIn = true;
    final items = await ApiService.getCart();
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  double get _subtotal {
    double sum = 0;
    for (var item in _items) {
      sum += item.subtotal;
    }
    return sum;
  }

  double get _gst => _subtotal * 0.18;
  double get _grandTotal => _subtotal + _gst;

  Future<void> _updateQty(CartItem item, int newQty) async {
    if (newQty < 1) return;
    final success = await ApiService.updateCartQty(item.id, newQty);
    if (success) {
      _loadCart();
    }
  }

  Future<void> _removeItem(CartItem item) async {
    final success = await ApiService.removeFromCart(item.id);
    if (success) {
      setState(() {
        _items.removeWhere((i) => i.id == item.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.productName} removed from cart')),
        );
      }
    }
  }

  void _checkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Text('🛍️ '),
            Text('Order Checkout'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Items: ${_items.length}'),
            const SizedBox(height: 6),
            Text('Subtotal: ₹${_subtotal.toStringAsFixed(2)}'),
            Text('GST (18%): ₹${_gst.toStringAsFixed(2)}'),
            const Divider(),
            Text(
              'Grand Total: ₹${_grandTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Cash on Delivery & Online Payment are available.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully! Thank you for shopping with BabyBloom.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shopping Cart')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 64, color: Colors.blueGrey),
                const SizedBox(height: 16),
                const Text(
                  'Please sign in to view your cart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    ).then((_) => _loadCart());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sign In / Register'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore our baby care catalog and add some favorites!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Start Shopping'),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Cart Items List
                ..._items.map((item) {
                  final imageUrl = AppConfig.getImageUrl(item.image);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 80,
                              height: 80,
                              color: const Color(0xFFF8FAFC),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Item Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${item.price.toStringAsFixed(0)} each',
                                  style: const TextStyle(
                                    color: Color(0xFF0284C7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    // Quantity selector
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: item.qty > 1
                                                ? () => _updateQty(item, item.qty - 1)
                                                : () => _removeItem(item),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              child: Text('-',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text('${item.qty}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold)),
                                          ),
                                          InkWell(
                                            onTap: () =>
                                                _updateQty(item, item.qty + 1),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              child: Text('+',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () => _removeItem(item),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Order Summary Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Items Subtotal'),
                            Text('₹${_subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('GST (18%)'),
                            Text('₹${_gst.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee'),
                            Text(
                              'FREE',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${_grandTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _checkout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Proceed to Checkout ➔',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

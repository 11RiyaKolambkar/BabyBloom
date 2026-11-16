import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../constants.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _cartCount = 0;
  bool _isLoggedIn = false;
  String? _username;

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = [
    {'name': 'All', 'icon': '✨'},
    {'name': 'Baby Care', 'icon': '🧴'},
    {'name': 'Toys & Learning', 'icon': '🧸'},
    {'name': 'Boys Fashion', 'icon': '👕'},
    {'name': 'Girls Fashion', 'icon': '👗'},
    {'name': 'Feeding & Nursing', 'icon': '🍼'},
    {'name': 'Diapering & Hygiene', 'icon': '🧷'},
    {'name': 'Bedding & Nursery', 'icon': '🛏️'},
    {'name': 'Baby Gear & Travel', 'icon': '🚼'},
  ];

  @override
  void initState() {
    super.initState();
    _checkAuth();
    _loadProducts();
    _loadCartCount();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await ApiService.isLoggedIn();
    final name = await ApiService.getStoredUsername();
    setState(() {
      _isLoggedIn = loggedIn;
      _username = name;
    });
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await ApiService.getProducts();
      setState(() {
        _allProducts = products;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load products: $e'),
            action: SnackBarAction(label: 'Retry', onPressed: _loadProducts),
          ),
        );
      }
    }
  }

  Future<void> _loadCartCount() async {
    final cart = await ApiService.getCart();
    int total = 0;
    for (var item in cart) {
      total += item.qty;
    }
    setState(() => _cartCount = total);
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _allProducts.filter((product) {
        final matchesCat = _selectedCategory == 'All' ||
            product.category.toLowerCase() == _selectedCategory.toLowerCase();
        final matchesQuery = _searchQuery.isEmpty ||
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.desc.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.category.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCat && matchesQuery;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  Future<void> _addToCart(Product product) async {
    final res = await ApiService.addToCart(product.id, 1);
    if (!mounted) return;

    if (res['success'] == true) {
      _loadCartCount();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'VIEW CART',
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              ).then((_) => _loadCartCount());
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Could not add to cart'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Text('🍼', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            const Text(
              'BabyBloom',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          // Cart with Counter Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF0F172A)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  ).then((_) => _loadCartCount());
                },
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),

          // User Profile / Logout Popup
          PopupMenuButton<String>(
            icon: const Icon(Icons.person_outline, color: Color(0xFF0F172A)),
            onSelected: (val) async {
              if (val == 'login') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ).then((_) => _checkAuth());
              } else if (val == 'logout') {
                await ApiService.logout();
                if (!context.mounted) return;
                _checkAuth();
                _loadCartCount();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              }
            },
            itemBuilder: (context) => [
              if (_isLoggedIn) ...[
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    'Signed in as ${_username ?? 'User'}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ] else ...[
                const PopupMenuItem(
                  value: 'login',
                  child: Row(
                    children: [
                      Icon(Icons.login, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text('Login / Register'),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadProducts();
          await _loadCartCount();
        },
        child: CustomScrollView(
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                      _applyFilters();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search baby lotion, toys, rompers...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _applyFilters();
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
              ),
            ),

            // Horizontal Category Pills
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat['name'];
                    return ChoiceChip(
                      label: Text('${cat['icon']} ${cat['name']}'),
                      selected: isSelected,
                      onSelected: (_) => _onCategorySelected(cat['name']!),
                      selectedColor: const Color(0xFF0284C7),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF334155),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF0284C7)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
            ),

            // Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory == 'All'
                          ? 'All Products'
                          : _selectedCategory,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${_filteredProducts.length} items',
                      style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            // Loading / Empty / Products Grid
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_filteredProducts.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔍', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      const Text(
                        'No products found',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Try searching for something else or reset filters',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _selectedCategory = 'All';
                            _searchQuery = '';
                            _applyFilters();
                          });
                        },
                        child: const Text('Reset Filters'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.64,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = _filteredProducts[index];
                      return _buildProductCard(product);
                    },
                    childCount: _filteredProducts.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final imageUrl = AppConfig.getImageUrl(product.primaryImage);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: product.id),
          ),
        ).then((_) => _loadCartCount());
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with rounded top corners
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  color: const Color(0xFFF8FAFC),
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          color: Colors.grey, size: 36),
                    ),
                  ),
                ),
              ),
            ),

            // Card Body
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          color: Color(0xFF0369A1),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color(0xFF0F172A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Price & Stock
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                        Text(
                          product.stock > 0 ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: product.stock > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: product.stock > 0 ? () => _addToCart(product) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBBF24),
                          foregroundColor: const Color(0xFF78350F),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ProductFilterExtension on List<Product> {
  Iterable<Product> filter(bool Function(Product) predicate) {
    return where(predicate);
  }
}

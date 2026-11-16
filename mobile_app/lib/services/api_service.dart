import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/cart_item.dart';

class ApiService {
  static const String _tokenKey = 'userToken';
  static const String _userEmailKey = 'userEmail';
  static const String _userNameKey = 'userName';

  // Auth: Check login status
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Auth: Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Auth: Get stored username
  static Future<String?> getStoredUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Auth: Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/user/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, data['token']);
        if (data['User'] != null) {
          await prefs.setString(_userEmailKey, data['User']['email'] ?? '');
          await prefs.setString(_userNameKey, data['User']['username'] ?? '');
        }
        return {'success': true, 'message': 'Login successful'};
      } else {
        final errorMsg = data['Error'] ?? data['message'] ?? 'Login failed';
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: Unable to connect to server ($e)'};
    }
  }

  // Auth: Register
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/user/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username.trim(),
          'email': email.trim().toLowerCase(),
          'phone': int.tryParse(phone) ?? phone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, data['token']);
        if (data['user'] != null) {
          await prefs.setString(_userEmailKey, data['user']['email'] ?? '');
          await prefs.setString(_userNameKey, data['user']['username'] ?? '');
        }
        return {'success': true, 'message': 'Registration successful'};
      } else {
        final errorMsg = data['Error'] ?? data['message'] ?? 'Registration failed';
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Auth: Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
  }

  // Products: Fetch all products
  static Future<List<Product>> getProducts() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/products');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['products'] != null && data['products'] is List) {
          return (data['products'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching products: $e');
      rethrow;
    }
  }

  // Products: Fetch single product details
  static Future<Product?> getProductDetails(String id) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/products/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['productDetails'] != null) {
          return Product.fromJson(data['productDetails']);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching product details: $e');
      return null;
    }
  }

  // Cart: Get Cart items
  static Future<List<CartItem>> getCart() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return [];

      final url = Uri.parse('${AppConfig.baseUrl}/cart');
      final response = await http.get(
        url,
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => CartItem.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching cart: $e');
      return [];
    }
  }

  // Cart: Add item to cart
  static Future<Map<String, dynamic>> addToCart(String productId, int qty) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Please login first to add items to cart'};
      }

      final url = Uri.parse('${AppConfig.baseUrl}/cart/add');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode({
          'p_id': productId,
          'qty': qty,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Item added to cart!'};
      } else {
        final data = jsonDecode(response.body);
        final msg = data['message'] ?? data['Error'] ?? 'Failed to add item to cart';
        return {'success': false, 'message': msg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Cart: Update quantity
  static Future<bool> updateCartQty(String cartId, int qty) async {
    try {
      final token = await getToken();
      final url = Uri.parse('${AppConfig.baseUrl}/cart/updateQty');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode({
          'cartId': cartId,
          'qty': qty,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Cart: Remove item from cart
  static Future<bool> removeFromCart(String cartItemId) async {
    try {
      final token = await getToken();
      final url = Uri.parse('${AppConfig.baseUrl}/cart/remove/$cartItemId');
      final response = await http.delete(
        url,
        headers: {'Authorization': token ?? ''},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // User Profile
  static Future<User?> getUserProfile() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final url = Uri.parse('${AppConfig.baseUrl}/user/getOne');
      final response = await http.get(
        url,
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

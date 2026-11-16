import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoginTab = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Login form controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Register form controllers
  final _regUsernameController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regPhoneController = TextEditingController();
  final _regPasswordController = TextEditingController();
  final _regConfirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _regUsernameController.dispose();
    _regEmailController.dispose();
    _regPhoneController.dispose();
    _regPasswordController.dispose();
    _regConfirmPasswordController.dispose();
    super.dispose();
  }

  void _switchTab(bool isLogin) {
    setState(() {
      _isLoginTab = isLogin;
      _errorMessage = null;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await ApiService.login(
      _loginEmailController.text.trim(),
      _loginPasswordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res['success'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful! Welcome back.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = res['message'];
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_regPasswordController.text != _regConfirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await ApiService.register(
      username: _regUsernameController.text.trim(),
      email: _regEmailController.text.trim(),
      phone: _regPhoneController.text.trim(),
      password: _regPasswordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res['success'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Welcome to BabyBloom.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = res['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App Brand Header
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2FE),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '🍼',
                                  style: TextStyle(fontSize: 36),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'BabyBloom',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Premium Baby Care & Essentials',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Toggle Buttons (Login vs Register)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _switchTab(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isLoginTab
                                        ? const Color(0xFF0284C7)
                                        : Colors.transparent,
                                    foregroundColor:
                                        _isLoginTab ? Colors.white : Colors.blueGrey,
                                    elevation: _isLoginTab ? 2 : 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _switchTab(false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !_isLoginTab
                                        ? const Color(0xFF0284C7)
                                        : Colors.transparent,
                                    foregroundColor:
                                        !_isLoginTab ? Colors.white : Colors.blueGrey,
                                    elevation: !_isLoginTab ? 2 : 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Error Banner
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Form Fields based on tab
                        if (_isLoginTab) ...[
                          TextFormField(
                            controller: _loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Please enter your email' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _loginPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Please enter your password' : null,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text(
                                    'Login to BabyBloom',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ] else ...[
                          TextFormField(
                            controller: _regUsernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Enter a username' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _regEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Enter your email' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _regPhoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: const Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Enter phone number' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _regPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.length < 4) ? 'At least 4 chars' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _regConfirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Confirm your password' : null,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],

                        const SizedBox(height: 16),
                        // Guest mode: continue to browse without login
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          },
                          child: const Text('Continue as Guest ➔'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

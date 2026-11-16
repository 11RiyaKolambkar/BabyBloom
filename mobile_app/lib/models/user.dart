class User {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String? address;
  final int? pincode;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.address,
    this.pincode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString(),
      pincode: json['pincode'] is num ? (json['pincode'] as num).toInt() : null,
    );
  }
}

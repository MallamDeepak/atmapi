class UserModel {
  final String id;
  final String fullName;
  final String accountNumber;
  final double balance;
  final String email;
  final String phone;

  UserModel({
    required this.id,
    required this.fullName,
    required this.accountNumber,
    required this.balance,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? 'User',
      accountNumber: json['accountNumber'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'accountNumber': accountNumber,
    'balance': balance,
    'email': email,
    'phone': phone,
  };

  UserModel copyWith({
    String? id,
    String? fullName,
    String? accountNumber,
    double? balance,
    String? email,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

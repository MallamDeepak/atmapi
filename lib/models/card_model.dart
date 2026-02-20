class CardModel {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final String cardType; // 'debit' or 'credit'
  final String network; // 'VISA', 'Mastercard', 'RuPay'
  final double? creditLimit;
  final double? balance;
  final bool isVirtual;
  final String? gradient; // Gradient identifier

  CardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    required this.cardType,
    required this.network,
    this.creditLimit,
    this.balance,
    this.isVirtual = false,
    this.gradient,
  });

  String get maskedCardNumber {
    if (cardNumber.length >= 4) {
      return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
    }
    return cardNumber;
  }

  String get last4Digits {
    if (cardNumber.length >= 4) {
      return cardNumber.substring(cardNumber.length - 4);
    }
    return cardNumber;
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      cardHolderName: json['cardHolderName'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      cvv: json['cvv'] ?? '',
      cardType: json['cardType'] ?? '',
      network: json['network'] ?? '',
      creditLimit: json['creditLimit']?.toDouble(),
      balance: json['balance']?.toDouble(),
      isVirtual: json['isVirtual'] ?? false,
      gradient: json['gradient'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardType': cardType,
      'network': network,
      'creditLimit': creditLimit,
      'balance': balance,
      'isVirtual': isVirtual,
      'gradient': gradient,
    };
  }
}

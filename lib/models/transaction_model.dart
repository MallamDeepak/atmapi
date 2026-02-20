class TransactionModel {
  final String id;
  final String type; // transfer, deposit, withdrawal
  final double amount;
  final String recipient;
  final DateTime timestamp;
  final String status; // success, pending, failed

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.recipient,
    required this.timestamp,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? 'transfer',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      recipient: json['recipient'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'success',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'amount': amount,
    'recipient': recipient,
    'timestamp': timestamp.toIso8601String(),
    'status': status,
  };

  String getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

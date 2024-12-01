class Transaction {
  final int id;
  final String type; // "recebimento" ou "dívida"
  final double amount;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}



class TransactionModel {
  TransactionModel({
    this.id,
    required this.amount,
    required this.description,
    this.periodId,
    required this.userUid,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return TransactionModel(
      id: id,
      amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : 0.0,
      description: map['description'] as String,
      periodId: map['periodId'] as String?,
      userUid: map['userUid'] as String? ?? '',
    );
  }

  final String? id;
  final double amount;
  final String description;
  final String? periodId;
  final String userUid;

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'description': description,
      'periodId': periodId,
      'userUid': userUid,
    }..removeWhere((key, value) => value == null);
  }
}

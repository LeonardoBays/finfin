import 'package:cloud_firestore/cloud_firestore.dart';

class PeriodSummaryModel {
  const PeriodSummaryModel({
    required this.id,
    required this.name,
    required this.userUid,
    required this.amount,
    required this.totalSpent,
    required this.remaining,
    required this.percentage,
    required this.startsAt,
    required this.endsAt,
    required this.daysLeft,
    required this.periodTypeId,
  });

  factory PeriodSummaryModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final startsAt = (map['startsAt'] is Timestamp)
        ? (map['startsAt'] as Timestamp).toDate()
        : DateTime.now();
    final endsAt = (map['endsAt'] is Timestamp)
        ? (map['endsAt'] as Timestamp).toDate()
        : DateTime.now();

    final amount = (map['amount'] is num)
        ? (map['amount'] as num).toDouble()
        : 0.0;
    final totalSpent = (map['totalSpent'] is num)
        ? (map['totalSpent'] as num).toDouble()
        : 0.0;
    final remaining = amount - totalSpent;
    final percentage = amount <= 0
        ? 0.0
        : ((totalSpent / amount) * 100).clamp(0.0, 100.0);
    final daysLeft = endsAt.difference(DateTime.now()).inDays;

    return PeriodSummaryModel(
      id: id ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      userUid: map['userUid'] as String? ?? '',
      amount: amount,
      totalSpent: totalSpent,
      remaining: remaining,
      percentage: percentage,
      startsAt: startsAt,
      endsAt: endsAt,
      daysLeft: daysLeft < 0 ? 0 : daysLeft,
      periodTypeId: (map['periodTypeId'] is int)
          ? map['periodTypeId'] as int
          : int.tryParse('${map['periodTypeId']}') ?? 0,
    );
  }

  final String id;
  final String name;
  final String userUid;
  final double amount;
  final double totalSpent;
  final double remaining;
  final double percentage;
  final DateTime startsAt;
  final DateTime endsAt;
  final int daysLeft;
  final int periodTypeId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userUid': userUid,
      'amount': amount,
      'totalSpent': totalSpent,
      'remaining': remaining,
      'percentage': percentage,
      'startsAt': Timestamp.fromDate(startsAt),
      'endsAt': Timestamp.fromDate(endsAt),
      'daysLeft': daysLeft,
      'periodTypeId': periodTypeId,
    };
  }
}

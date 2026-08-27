import 'package:cloud_firestore/cloud_firestore.dart';

class PeriodModel {
  factory PeriodModel.fromMap(Map<String, dynamic> map, {String? id}) {
    Timestamp? tsFrom(dynamic v) => v is Timestamp ? v : null;

    return PeriodModel(
      id: id,
      amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : 0.0,
      deletedAt: tsFrom(map['deletedAt'])?.toDate(),
      endsAt: (tsFrom(map['endsAt']) ?? Timestamp.fromDate(DateTime.now()))
          .toDate(),
      name: map['name'] as String? ?? '',
      periodTypeId: (map['periodTypeId'] is int)
          ? map['periodTypeId'] as int
          : int.tryParse('${map['periodTypeId']}') ?? 0,
      startsAt: (tsFrom(map['startsAt']) ?? Timestamp.fromDate(DateTime.now()))
          .toDate(),
      updatedAt:
          (tsFrom(map['updatedAt']) ?? Timestamp.fromDate(DateTime.now()))
              .toDate(),
      userUid: map['userUid'] as String? ?? '',
    );
  }

  PeriodModel({
    this.id,
    required this.amount,
    this.deletedAt,
    required this.endsAt,
    required this.name,
    required this.periodTypeId,
    required this.startsAt,
    required this.updatedAt,
    required this.userUid,
  });

  final String? id;
  final double amount;
  final DateTime? deletedAt;
  final DateTime endsAt;
  final String name;
  final int periodTypeId;
  final DateTime startsAt;
  final DateTime updatedAt;
  final String userUid;

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'endsAt': Timestamp.fromDate(endsAt),
      'name': name,
      'periodTypeId': periodTypeId,
      'startsAt': Timestamp.fromDate(startsAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'userUid': userUid,
    }..removeWhere((key, value) => value == null);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRemoteRepository implements TransactionRepository {
  TransactionRemoteRepository(FirebaseFirestore firestore)
    : firestore = firestore,
      _col = firestore.collection('transactions');
  final FirebaseFirestore firestore;
  final CollectionReference _col;

  @override
  Future<String> create(TransactionModel transaction) async {
    final docRef = await _col.add(transaction.toMap());
    return docRef.id;
  }

  @override
  Future<void> update(TransactionModel transaction) async {
    if (transaction.id == null) {
      throw ArgumentError('Transaction id is required for update');
    }
    await _col.doc(transaction.id).set(transaction.toMap());
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  @override
  Future<TransactionModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return TransactionModel.fromMap(
      doc.data() as Map<String, dynamic>,
      id: doc.id,
    );
  }

  @override
  Future<List<TransactionModel>> listByUser(String userUid) async {
    final snap = await _col.where('userUid', isEqualTo: userUid).get();
    return snap.docs
        .map(
          (d) => TransactionModel.fromMap(
            d.data() as Map<String, dynamic>,
            id: d.id,
          ),
        )
        .toList();
  }

  @override
  Future<List<TransactionModel>> listByPeriodId(String periodId) async {
    final snap = await _col.where('periodId', isEqualTo: periodId).get();
    return snap.docs
        .map(
          (d) => TransactionModel.fromMap(
            d.data() as Map<String, dynamic>,
            id: d.id,
          ),
        )
        .toList();
  }
}

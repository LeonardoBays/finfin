import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/period_model.dart';
import '../../domain/repositories/period_repository.dart';

class PeriodRemoteRepository implements PeriodRepository {
  PeriodRemoteRepository(FirebaseFirestore firestore)
    : firestore = firestore,
      _col = firestore.collection('periods');
  final FirebaseFirestore firestore;
  final CollectionReference _col;

  @override
  Future<String> create(PeriodModel period) async {
    final docRef = await _col.add(period.toMap());
    return docRef.id;
  }

  @override
  Future<void> update(PeriodModel period) async {
    if (period.id == null) {
      throw ArgumentError('Period id is required for update');
    }
    await _col.doc(period.id).set(period.toMap());
  }

  @override
  Future<void> delete(String id) async {
    // Delete all transactions that belong to this period first
    final transactionsCol = firestore.collection('transactions');
    final txSnap = await transactionsCol.where('periodId', isEqualTo: id).get();

    // Firestore batches have a 500 operation limit. Commit in chunks if needed.
    const batchLimit = 490; // leave room for the period delete operation
    final docs = txSnap.docs;
    for (var i = 0; i < docs.length; i += batchLimit) {
      final batch = firestore.batch();
      final end = (i + batchLimit) > docs.length
          ? docs.length
          : (i + batchLimit);
      for (var j = i; j < end; j++) {
        batch.delete(docs[j].reference);
      }
      // If this is the last chunk, also delete the period document in the same batch
      if (end == docs.length) {
        batch.delete(_col.doc(id));
      }
      await batch.commit();
    }

    // If there were no transactions, delete the period directly
    if (docs.isEmpty) {
      await _col.doc(id).delete();
    }
  }

  @override
  Future<PeriodModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return PeriodModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
  }

  @override
  Future<List<PeriodModel>> listByUser(String userUid) async {
    final snap = await _col.where('userUid', isEqualTo: userUid).get();
    return snap.docs
        .map(
          (d) =>
              PeriodModel.fromMap(d.data() as Map<String, dynamic>, id: d.id),
        )
        .toList();
  }
}

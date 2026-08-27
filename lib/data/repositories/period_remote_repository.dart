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
    await _col.doc(id).delete();
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

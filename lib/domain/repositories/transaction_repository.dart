import '../../data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<String> create(TransactionModel transaction);
  Future<void> update(TransactionModel transaction);
  Future<void> delete(String id);
  Future<TransactionModel?> getById(String id);
  Future<List<TransactionModel>> listByUser(String userUid);
}

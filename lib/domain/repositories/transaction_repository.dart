import '../../data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getTransactions();

  Future<void> addTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);

  Future<void> clearTransactions();
}
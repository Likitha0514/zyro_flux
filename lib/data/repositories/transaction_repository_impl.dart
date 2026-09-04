import '../../core/storage/local_storage_service.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final LocalStorageService localStorage;

  TransactionRepositoryImpl(this.localStorage);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final data = await localStorage.readData();

    final transactions = data['transactions'] as List? ?? [];

    return transactions
        .map(
          (transaction) => TransactionModel.fromJson(
            Map<String, dynamic>.from(transaction),
          ),
        )
        .toList();
  }

  @override
  Future<void> addTransaction(
    TransactionModel transaction,
  ) async {
    final data = await localStorage.readData();

    final transactions = data['transactions'] as List? ?? [];

    transactions.add(transaction.toJson());

    data['transactions'] = transactions;

    await localStorage.writeData(data);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final data = await localStorage.readData();

    final transactions = data['transactions'] as List? ?? [];

    transactions.removeWhere(
      (item) => item['id'] == id,
    );

    data['transactions'] = transactions;

    await localStorage.writeData(data);
  }

  @override
  Future<void> clearTransactions() async {
    final data = await localStorage.readData();

    data['transactions'] = [];

    await localStorage.writeData(data);
  }
}
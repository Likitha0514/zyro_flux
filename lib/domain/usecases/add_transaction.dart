import '../../data/models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<void> call(TransactionModel transaction) {
    return repository.addTransaction(transaction);
  }
}
import '../repositories/transaction_repository.dart';

class ClearTransactions {
  final TransactionRepository repository;

  ClearTransactions(this.repository);

  Future<void> call() {
    return repository.clearTransactions();
  }
}
import '../../data/models/transaction_model.dart';

class CalculateBalance {
  double income(List<TransactionModel> transactions) {
    return transactions
        .where((transaction) => transaction.type == 'income')
        .fold(
          0,
          (total, transaction) => total + transaction.amount,
        );
  }

  double spent(List<TransactionModel> transactions) {
    return transactions
        .where((transaction) => transaction.type == 'spent')
        .fold(
          0,
          (total, transaction) => total + transaction.amount,
        );
  }

  double balance(List<TransactionModel> transactions) {
    return income(transactions) - spent(transactions);
  }
}
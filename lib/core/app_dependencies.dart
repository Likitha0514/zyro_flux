import 'package:zyro_flux/core/storage/password_storage_service.dart';

import 'storage/local_storage_service.dart';

import '../data/repositories/emi_repository_impl.dart';
import '../data/repositories/transaction_repository_impl.dart';

import '../domain/usecases/add_emi.dart';
import '../domain/usecases/update_emi.dart';
import '../domain/usecases/delete_emi.dart';
import '../domain/usecases/get_emis.dart';
import '../domain/usecases/clear_emis.dart';
import '../domain/usecases/calculate_monthly_emi.dart';

import '../domain/usecases/add_transaction.dart';
import '../domain/usecases/delete_transaction.dart';
import '../domain/usecases/get_transactions.dart';
import '../domain/usecases/clear_transactions.dart';
import '../domain/usecases/calculate_balance.dart';

class AppDependencies {
  final LocalStorageService localStorage;

  late final EmiRepositoryImpl emiRepository;
  late final TransactionRepositoryImpl transactionRepository;

  late final AddEmi addEmi;
  late final UpdateEmi updateEmi;
  late final DeleteEmi deleteEmi;
  late final GetEmis getEmis;
  late final ClearEmis clearEmis;
  late final CalculateMonthlyEmi calculateMonthlyEmi;

  late final AddTransaction addTransaction;
  late final DeleteTransaction deleteTransaction;
  late final GetTransactions getTransactions;
  late final ClearTransactions clearTransactions;
  late final CalculateBalance calculateBalance;
  late final PasswordStorageService passwordStorage;
  AppDependencies(this.localStorage) {
    emiRepository = EmiRepositoryImpl(localStorage);
    transactionRepository = TransactionRepositoryImpl(localStorage);

    addEmi = AddEmi(emiRepository);
    updateEmi = UpdateEmi(emiRepository);
    deleteEmi = DeleteEmi(emiRepository);
    getEmis = GetEmis(emiRepository);
    clearEmis = ClearEmis(emiRepository);
    calculateMonthlyEmi = CalculateMonthlyEmi();

    addTransaction = AddTransaction(transactionRepository);
    deleteTransaction = DeleteTransaction(transactionRepository);
    getTransactions = GetTransactions(transactionRepository);
    clearTransactions = ClearTransactions(transactionRepository);
    calculateBalance = CalculateBalance();
    passwordStorage = PasswordStorageService(localStorage);
  }
}

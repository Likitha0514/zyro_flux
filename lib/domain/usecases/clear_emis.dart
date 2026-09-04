import '../repositories/emi_repository.dart';

class ClearEmis {
  final EmiRepository repository;

  ClearEmis(this.repository);

  Future<void> call() {
    return repository.clearEmis();
  }
}
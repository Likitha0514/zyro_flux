import '../../data/models/emi_model.dart';
import '../repositories/emi_repository.dart';

class UpdateEmi {
  final EmiRepository repository;

  UpdateEmi(this.repository);

  Future<void> call(EmiModel emi) {
    return repository.updateEmi(emi);
  }
}
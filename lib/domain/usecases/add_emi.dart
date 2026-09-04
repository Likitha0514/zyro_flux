import '../../data/models/emi_model.dart';
import '../repositories/emi_repository.dart';

class AddEmi {
  final EmiRepository repository;

  AddEmi(this.repository);

  Future<void> call(EmiModel emi) {
    return repository.addEmi(emi);
  }
}
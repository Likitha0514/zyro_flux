import '../../data/models/emi_model.dart';
import '../repositories/emi_repository.dart';

class GetEmis {
  final EmiRepository repository;

  GetEmis(this.repository);

  Future<List<EmiModel>> call() {
    return repository.getEmis();
  }
}
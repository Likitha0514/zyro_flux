import '../repositories/emi_repository.dart';

class DeleteEmi {
  final EmiRepository repository;

  DeleteEmi(this.repository);

  Future<void> call(String id) {
    return repository.deleteEmi(id);
  }
}
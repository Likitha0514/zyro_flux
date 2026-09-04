import '../../data/models/emi_model.dart';

abstract class EmiRepository {
  Future<List<EmiModel>> getEmis();

  Future<void> addEmi(EmiModel emi);

  Future<void> updateEmi(EmiModel emi);

  Future<void> deleteEmi(String id);
}
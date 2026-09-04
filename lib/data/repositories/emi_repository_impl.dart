import '../../core/storage/local_storage_service.dart';
import '../../data/models/emi_model.dart';
import '../../domain/repositories/emi_repository.dart';

class EmiRepositoryImpl implements EmiRepository {
  final LocalStorageService localStorage;

  EmiRepositoryImpl(this.localStorage);

  @override
  Future<List<EmiModel>> getEmis() async {
    final data = await localStorage.readData();

    final emis = data['emis'] as List? ?? [];

    return emis
        .map(
          (emi) => EmiModel.fromJson(
            Map<String, dynamic>.from(emi),
          ),
        )
        .toList();
  }

  @override
  Future<void> addEmi(EmiModel emi) async {
    final data = await localStorage.readData();

    final emis = data['emis'] as List? ?? [];

    emis.add(emi.toJson());

    data['emis'] = emis;

    await localStorage.writeData(data);
  }

  @override
  Future<void> updateEmi(EmiModel emi) async {
    final data = await localStorage.readData();

    final emis = data['emis'] as List? ?? [];

    final index = emis.indexWhere(
      (item) => item['id'] == emi.id,
    );

    if (index == -1) return;

    emis[index] = emi.toJson();

    data['emis'] = emis;

    await localStorage.writeData(data);
  }

  @override
  Future<void> deleteEmi(String id) async {
    final data = await localStorage.readData();

    final emis = data['emis'] as List? ?? [];

    emis.removeWhere(
      (item) => item['id'] == id,
    );

    data['emis'] = emis;

    await localStorage.writeData(data);
  }
}
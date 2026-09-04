import 'local_storage_service.dart';

class PasswordStorageService {
  final LocalStorageService localStorage;

  PasswordStorageService(this.localStorage);

  Future<bool> hasPassword() async {
    final data = await localStorage.readData();

    return data['password'] != null;
  }

  Future<void> savePassword(String password) async {
    final data = await localStorage.readData();

    data['password'] = password;

    await localStorage.writeData(data);
  }

  Future<bool> verifyPassword(String password) async {
    final data = await localStorage.readData();

    return data['password'] == password;
  }
}
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proyecto_analisis/resources/constants.dart';

class UserRepository {
  static const String password = 'password';
  static const String name = 'name';
  static const String scheme = 'scheme';
  static const String token = 'token';

  final FlutterSecureStorage storage;

  UserRepository() : storage = const FlutterSecureStorage();

  UserRepository.withStorage(
    this.storage,
  );

  Future<String> getPassword() async {
    return (await storage.read(
          key: password,
        )) ??
        emptyString;
  }

  Future<void> setPassword(
    final String passwordValue,
  ) async {
    (await storage.write(
      key: password,
      value: passwordValue,
    ));
  }

  Future<String> getName() async {
    return (await storage.read(
          key: name,
        )) ??
        emptyString;
  }

  Future<void> setName(
    final String nameValue,
  ) async {
    (await storage.write(
      key: name,
      value: nameValue,
    ));
  }

  Future<String> getScheme() async {
    return (await storage.read(
          key: scheme,
        )) ??
        emptyString;
  }

  Future<void> setScheme(
    final String schemeValue,
  ) async {
    (await storage.write(
      key: scheme,
      value: schemeValue,
    ));
  }

  Future<String> getToken() async {
    return (await storage.read(
          key: token,
        )) ??
        emptyString;
  }

  Future<void> setToken(
    String tokenValue,
  ) async {
    await storage.write(
      key: token,
      value: tokenValue,
    );
  }
}

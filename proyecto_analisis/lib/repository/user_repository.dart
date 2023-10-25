import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proyecto_analisis/resources/constants.dart';

class UserRepository {
  static const String password = 'password';
  static const String name = 'name';
  static const String email = 'email';
  static const String scheme = 'scheme';
  static const String token = 'token';
  static const String id = 'id';
  static const String passwordPolicy = 'passwordPolicy';
  static const String user = 'user';

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

  Future<String> getId() async {
    return (await storage.read(
          key: id,
        )) ??
        emptyString;
  }

  Future<void> setId(
    final String idValue,
  ) async {
    (await storage.write(
      key: id,
      value: idValue,
    ));
  }

  Future<String> getPasswordPolicy() async {
    return (await storage.read(
          key: passwordPolicy,
        )) ??
        emptyString;
  }

  Future<void> setPasswordPolicy(
    final String passwordPolicyValue,
  ) async {
    (await storage.write(
      key: passwordPolicy,
      value: passwordPolicyValue,
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

  Future<String> getUser() async {
    return (await storage.read(
          key: user,
        )) ??
        emptyString;
  }

  Future<void> setUser(
    final String nameValue,
  ) async {
    (await storage.write(
      key: user,
      value: nameValue,
    ));
  }

  Future<String> getEmail() async {
    return (await storage.read(
          key: email,
        )) ??
        emptyString;
  }

  Future<void> setEmail(
    final String emailValue,
  ) async {
    (await storage.write(
      key: email,
      value: emailValue,
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

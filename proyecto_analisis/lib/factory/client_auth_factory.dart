import 'package:dio/dio.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

class ClientAuthFactory {
  static Dio client = Dio();

  static Dio buildClient(
    final String baseUrl,
  ) {
    final clientOptions = BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (int? status) => status! <= 200,
    );

    client = Dio(
      clientOptions,
    );

    client.interceptors.add(InterceptorsWrapper(
        onRequest: addAuthenticationInterceptor,
        onError: addErrorInterceptor,
        //TODO: Eliminar al terminar pruebas
        onResponse: (e, h) {
          print(e.realUri.toString());
          print(e.headers);
          print(e.data);
          print(e.statusCode);
          return h.next(e);
        }));
    return client;
  }

  static dynamic addAuthenticationInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final repository = UserRepository();
    final authToken = await repository.getToken();

    options.headers['Accept'] = '*/*';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Encoding'] = 'gzip, deflate, br';
    options.headers['Connection'] = 'keep-alive';
    options.headers['Authorization'] = 'Bearer $authToken';

    return handler.next(options);
  }

  static dynamic addErrorInterceptor(
    DioError error,
    ErrorInterceptorHandler errorHandler,
  ) async {
    //TODO: Eliminar al terminar pruebas
    print(error.requestOptions.uri.toString());
    print(error.requestOptions.headers);
    print(error.requestOptions.data);
    print(error.message);
    print(error.response?.statusCode.toString());
    print(error.response?.data);
    return errorHandler.next(error);
  }
}

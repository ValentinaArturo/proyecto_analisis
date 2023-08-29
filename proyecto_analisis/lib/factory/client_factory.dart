import 'package:dio/dio.dart';

class ClientFactory {
  static Dio client = Dio();

  static Dio buildClient(
    final String baseUrl,
  ) {
    final clientOptions = BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (status) => status! <= 200,
    );

    client = Dio(
      clientOptions,
    );
    client.interceptors.add(InterceptorsWrapper(
      onRequest: addAuthenticationInterceptor,
      onError: addErrorInterceptor,
    ));
    return client;
  }

  static dynamic addAuthenticationInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = '*/*';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Encoding'] = 'gzip, deflate, br';
    options.headers['Connection'] = 'keep-alive';

    return handler.next(options);
  }

  static dynamic addErrorInterceptor(
    DioError error,
    ErrorInterceptorHandler errorHandler,
  ) async {
    errorHandler.next(
      error,
    );
  }
}

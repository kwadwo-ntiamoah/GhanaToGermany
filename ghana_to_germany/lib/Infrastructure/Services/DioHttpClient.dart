import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IHttpClient.dart';

class ErrorResponse {
  String type, title, traceId;
  num status;

  ErrorResponse(
      {required this.type,
      required this.title,
      required this.traceId,
      required this.status});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
        type: json['type'],
        title: json['title'],
        traceId: json['traceId'],
        status: json['status']);
  }
}

class HttpException implements Exception {
  final String message;
  final int? statusCode;

  HttpException(this.message, {this.statusCode});

  @override
  String toString() {
    return message;
  }
}

class ForbiddenException implements Exception {
  final String message;
  final int? statusCode;

  ForbiddenException(this.message, {this.statusCode});

  @override
  String toString() {
    return message;
  }
}

class DioHttpClient implements IHttpClient {
  final Dio dio;
  final IAuthProvider authProvider;

  DioHttpClient({required this.dio, required this.authProvider}) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Retrieve the token from Shared Preferences
        var token = authProvider.getToken(); // Adjust the key as needed

        if (token != null) {
          // Add the token to the headers
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        return handler.next(response); // Continue with the response
      },
      onError: (DioException e, handler) {
        return handler.next(e); // Continue with the error
      },
    ));
  }

  @override
  Future<T> get<T>(String route) async {
    try {
      var url = "http://140.238.70.213:3000/api/";
      //var url = "http://localhost:5118/api/";

      final response = await dio.get(url + route);
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<T> post<T>(String route, dynamic payload) async {
    try {
      var url = "http://140.238.70.213:3000/api/";
      //var url = "http://localhost:5118/api/";

      final response = await dio.post(url + route, data: payload);
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  T _handleResponse<T>(Response response) {
    switch (response.statusCode) {
      case 200:
        // if type of response is a string, decode to json
        // otherwise cast as T
        if (response.data is String) {
          var decodedData = jsonDecode(response.data);
          return decodedData as T;
        }

        return response.data as T; // OK
      case 201:
        return response.data as T; // Created
      case 400:
      case 401:
      case 403:
        throw ForbiddenException("Unauthorized");
      case 404:
      case 405:
      case 409:
      case 500:
        var error = ErrorResponse.fromJson(response.data);
        throw HttpException(error.title, statusCode: response.statusCode);

      default:
        var error = ErrorResponse.fromJson(response.data);
        throw HttpException(error.title, statusCode: response.statusCode);
    }
  }

  HttpException _handleDioError(DioException e) {
    if (e.response != null) {
      // If the server responded with an error
      return _handleResponse(e.response!);
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return HttpException('Connection Timeout');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return HttpException('Receive Timeout');
    } else if (e.type == DioExceptionType.sendTimeout) {
      return HttpException('Send Timeout');
    } else if (e.type == DioExceptionType.unknown) {
      return HttpException('Network Error: ${e.message}');
    } else {
      return HttpException('Unexpected error: ${e.message}');
    }
  }
}

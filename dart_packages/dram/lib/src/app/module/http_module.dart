import 'package:dio/dio.dart' as d;
import 'package:dram/src/app/http/api_response.dart';

import 'module.dart';

/// An http module adds HTTP funcionallity to the app
class HttpModule extends Module {

  late d.Dio _dio;

  HttpModule({required String endpoint, Duration? timeout, String? contentType, ResponseType? responseType}) {
    _dio = d.Dio(d.BaseOptions(
      baseUrl: endpoint,
      connectTimeout: timeout?.inMilliseconds,
      contentType: contentType,
      responseType: _getResponseType(responseType),
    ));
  }

  Future<ApiResponse> sendGet(String resource, {Map<String, dynamic>? params}) async {
    try {
      d.Response response = await _dio.get(resource, queryParameters: params);
      return ApiResponse.fromResponse(response);

    } on d.DioError catch(err) {
      return _handleError(err);
    }
  }

  Future<ApiResponse> sendPost(String resource, {dynamic body, Map<String, dynamic>? params}) async {
    try {
      d.Response response = await _dio.post(resource, queryParameters: params, data: body);
      return ApiResponse.fromResponse(response);

    } on d.DioError catch(err) {
      return _handleError(err);
    }
  }

  Future<ApiResponse> sendPatch(String resource, {dynamic body, Map<String, dynamic>? params}) async {
    try {
      d.Response response = await _dio.patch(resource, queryParameters: params, data: body);
      return ApiResponse.fromResponse(response);

    } on d.DioError catch(err) {
      return _handleError(err);
    }
  }

  Future<ApiResponse> sendPut(String resource, {dynamic body, Map<String, dynamic>? params}) async {
    try {
      d.Response response = await _dio.put(resource, queryParameters: params, data: body);
      return ApiResponse.fromResponse(response);

    } on d.DioError catch(err) {
      return _handleError(err);
    }
  }

  Future<ApiResponse> sendDelete(String resource, {dynamic body, Map<String, dynamic>? params}) async {
    try {
      d.Response response = await _dio.delete(resource, queryParameters: params, data: body);
      return ApiResponse.fromResponse(response);

    } on d.DioError catch(err) {
      return _handleError(err);
    }
  }

  d.ResponseType _getResponseType(ResponseType? responseType) {
    switch(responseType) {
      case ResponseType.bytes:
        return d.ResponseType.bytes;

      case ResponseType.plain:
        return d.ResponseType.plain;

      default:
        return d.ResponseType.json;
    }
  }

  ApiResponse _handleError(d.DioError error) {
    return ApiResponse.fromException(error.message);
  }
  
}

enum ResponseType {
  json,
  bytes,
  plain
}
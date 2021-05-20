import 'package:dio/dio.dart';

class ApiResponse {

  bool? _success;
  String? _errorCode;
  dynamic _data;

  bool get isSuccess => _success!;
  bool get isFailed => !_success!;
  String? get errorCode => _errorCode;
  dynamic get data => _data;

  ApiResponse._(bool success, [String? errorCode, dynamic data]) {
    this._success = success;
    this._errorCode = errorCode;
    this._data = data;
  }

  factory ApiResponse.successful([dynamic data]) {
    return ApiResponse._(true, null, data);
  }

  factory ApiResponse.failed([String? error, dynamic data]) {
    return ApiResponse._(false, error, data);
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse._(json["success"], json["error"], json["data"]);
  }

  factory ApiResponse.fromException(String ex) {
    return ApiResponse._(false, ex);
  }

  factory ApiResponse.fromResponse(Response response) {
    var data = response.data;
    if(data is Map) {
      if(data.containsKey("success")) {
        return ApiResponse.fromJson(data.cast<String, dynamic>());
      } else {
        return ApiResponse.failed(response.statusMessage);
      }
    }

    throw new Exception("Cannot convert response due its data type: $data");
  }

}
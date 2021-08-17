import 'package:dio/dio.dart';

import '../models/request_model.dart';

var _header = <String, String>{};
var _token = <String, String>{};
var _baseUrl = '';

class BaseRequestDefaults {
  BaseRequestDefaults._();

  static final _instance = BaseRequestDefaults._();

  static BaseRequestDefaults get instance => _instance;

  void setHeader(Map<String, String> header) => _header = header;
  void setToken(Map<String, String> token) => _token = token;
  void setBaseUrl(String baseUrl) => _baseUrl = baseUrl;
}

abstract class BaseRequest {
  BaseRequest(
    this.path,
    this.method,
    this.queryParameters,
    this.requestModel,
    this.data,
  );

  final RequestModel requestModel;
  final String path;
  final String method;
  final Future<Map<String, dynamic>?> queryParameters;
  final Future<dynamic> data;
}

mixin Request implements BaseRequest {
  String get baseUrl => _baseUrl;
  String get url => baseUrl + path;
  CancelToken get cancelToken => requestModel.cancelToken;
  bool get includeAuthorization => true;
  Map<String, String>? get headers {
    final headers = <String, String>{};
    headers.addAll(_header);
    if (_token.isNotEmpty && includeAuthorization) headers.addAll(_token);
    return headers;
  }
}

mixin PostRequest on Request {
  @override
  Future<Map<String, dynamic>?> get queryParameters async => null;
  @override
  Future<dynamic> get data async {
    final map = await requestModel.toMap();
    if (map.isEmpty) return null;
    return FormData.fromMap(map);
  }

  @override
  String get method => 'POST';
}

mixin GetRequest on Request {
  @override
  RequestModel get requestModel => EmptyRequestModel();

  @override
  Future<Map<String, dynamic>?> get queryParameters async {
    final map = await requestModel.toMap();
    return map.isEmpty ? null : requestModel.toMap();
  }

  @override
  Future<dynamic> get data async => null;

  @override
  String get method => 'GET';
}

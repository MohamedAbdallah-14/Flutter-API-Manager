import 'package:test/test.dart';
import 'package:dio/dio.dart';

import 'package:api_manager/api_manager.dart';

class RequestModelMock extends RequestModel {
  RequestModelMock(
      {RequestProgressListener? progressListener, required this.data})
      : super(progressListener);

  final String data;

  @override
  List<Object?> get props => [data];

  @override
  Future<Map<String, dynamic>> toMap() async {
    return {'data': 'data_mock'};
  }
}

class RequestMock with Request {
  RequestMock(this.requestModel);

  @override
  final RequestModel requestModel;

  @override
  Future<dynamic> get data async => {'data': 'data_mock'};

  @override
  String get method => 'GET';

  @override
  String get path => 'path';

  @override
  Future<Map<String, dynamic>> get queryParameters async =>
      {'parameter': 'mock'};
}

class RequestMockWihoutAuthorization with Request {
  RequestMockWihoutAuthorization(this.requestModel);

  @override
  final RequestModel requestModel;

  @override
  Future<dynamic> get data async => {'data': 'data_mock'};

  @override
  String get method => 'GET';

  @override
  bool get includeAuthorization => false;

  @override
  String get path => 'path';

  @override
  Future<Map<String, dynamic>> get queryParameters async =>
      {'parameter': 'mock'};
}

class GetRequestMock with Request, GetRequest {
  GetRequestMock(this.requestModel);

  @override
  final RequestModel requestModel;

  @override
  String get path => 'path';
}

class PostRequestMock with Request, PostRequest {
  PostRequestMock(this.requestModel);

  @override
  final RequestModel requestModel;

  @override
  String get path => 'path';
}

void main() {
  const baseUrl = 'http://localhost/';
  final headers = {'lang': 'en'};
  const token = {'Authorization': 'Bearer token'};

  setUpAll(() {
    BaseRequestDefaults.instance.setBaseUrl(baseUrl);
    BaseRequestDefaults.instance.setHeader(headers);
    BaseRequestDefaults.instance.setToken(token);
  });

  group('Base Request', () {
    late RequestMock request;
    late RequestMockWihoutAuthorization requestWihoutAuthorization;
    late RequestModelMock requestModel;

    setUp(() {
      requestModel = RequestModelMock(data: 'data_mock');
      request = RequestMock(requestModel);
      requestWihoutAuthorization = RequestMockWihoutAuthorization(requestModel);
    });

    test('should generate right url', () async {
      expect(request.baseUrl, baseUrl);
      expect(request.url, '${baseUrl}path');
    });

    test('should referance request model canceltoekn', () async {
      expect(request.cancelToken, requestModel.cancelToken);
    });

    test('should contain the header', () async {
      expect(request.headers, headers..addAll(token));
    });

    test('should not contain token if includeAuthorization is false', () async {
      expect(requestWihoutAuthorization.headers, headers);
    });
  });

  group('Get Request', () {
    late GetRequestMock getRequest;
    late RequestModelMock requestModel;

    setUp(() {
      requestModel = RequestModelMock(data: 'data_mock');
      getRequest = GetRequestMock(requestModel);
    });

    group('should behave same as base', () {
      test('should generate right url', () async {
        expect(getRequest.baseUrl, baseUrl);
        expect(getRequest.url, '${baseUrl}path');
      });

      test('should referance request model canceltoekn', () async {
        expect(getRequest.cancelToken, requestModel.cancelToken);
      });
    });

    test('method should be GET', () async {
      expect(getRequest.method, 'GET');
    });

    test('data should be {}', () async {
      expect(await getRequest.data, null);
    });

    test('queryParameters should be requestModel.toMap', () async {
      expect(await getRequest.queryParameters, await requestModel.toMap());
    });
  });

  group('Post Request', () {
    late PostRequestMock postRequest;
    late RequestModelMock requestModel;

    setUp(() {
      requestModel = RequestModelMock(data: 'data_mock');
      postRequest = PostRequestMock(requestModel);
    });

    group('should behave same as base', () {
      test('should generate right url', () async {
        expect(postRequest.baseUrl, baseUrl);
        expect(postRequest.url, '${baseUrl}path');
      });

      test('should referance request model canceltoekn', () async {
        expect(postRequest.cancelToken, requestModel.cancelToken);
      });
    });

    test('method should be POST', () async {
      expect(postRequest.method, 'POST');
    });

    test('data should be equestModel.toMap', () async {
      expect((await postRequest.data as FormData).fields.first.value,
          FormData.fromMap(await requestModel.toMap()).fields.first.value);
    });

    test('queryParameters should be null', () async {
      expect(await postRequest.queryParameters, null);
    });
  });
}

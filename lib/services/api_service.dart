import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/models/add_face_response_model.dart';
import 'package:face_detector/models/error_response_model.dart';
import 'package:face_detector/models/recognize_response_model.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:flutter/material.dart';

class ApiService {
  final _storage = locator.get<StorageService>();
  final Dio _dio = Dio();
  CancelToken _cancelToken = CancelToken();

  static const String subjectsPath = '/api/v1/recognition/subjects';
  static const String recognizePath = '/api/v1/recognition/recognize';
  static const String addFacePath = '/api/v1/recognition/faces';

  static const timeoutDuration = Duration(seconds: 15);

  ApiService() {
    _dio.options.baseUrl = CommonUtils.getValidBaseUrl(_storage.getBaseUrl());
    _dio.options.connectTimeout = timeoutDuration;
    _dio.options.receiveTimeout = timeoutDuration;
    _dio.options.sendTimeout = timeoutDuration;
  }

  void updateBaseUrl(String url) {
    _dio.options.baseUrl = CommonUtils.getValidBaseUrl(url);
  }

  Future<ApiResponse> getSubjects() async {
    try {
      Response response = await _dio.get(
        subjectsPath,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': _storage.getApiKey(),
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint(data.toString());
        List<String> subjects = List<String>.from(data['subjects']);

        return ApiResponse(data: subjects, error: null);
      }
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(response.data);

      return ApiResponse(data: null, error: errorResponseModel.message);
    } on TimeoutException catch (_) {
      return const ApiResponse(data: null, error: 'Request timeout');
    } on DioException catch (error) {
      return parseDioError(error);
    } catch (error, stack) {
      debugPrint(stack.toString());
      return ApiResponse(data: null, error: 'Error in getSubjects: $error');
    }
  }

  Future<ApiResponse> addFace(String name, Uint8List fileBytes) async {
    FormData formData = FormData.fromMap({
      'subject': name,
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: 'face_reco.jpg',
        contentType: DioMediaType.parse('image/jpeg'),
      ),
    });

    try {
      Response response = await _dio.post(
        addFacePath,
        data: formData,
        options: Options(
          headers: {
            'x-api-key': _storage.getApiKey(),
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        AddFaceResponseModel recognized = AddFaceResponseModel.fromJson(data);

        return ApiResponse(data: recognized, error: null);
      }
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(response.data);

      return ApiResponse(data: null, error: errorResponseModel.message);
    } on TimeoutException catch (_) {
      return const ApiResponse(data: null, error: 'Request timeout');
    } on DioException catch (error) {
      return parseDioError(error);
    } catch (error, stack) {
      debugPrint(error.toString());
      debugPrint(stack.toString());
      return ApiResponse(data: null, error: 'Error in addFace: $error');
    }
  }

  Future<ApiResponse> recognizeFilePath(String filePath) async {
    // avoid multiple calls
    cancelOngoingRequests();
    _cancelToken = CancelToken();

    FormData formData = FormData.fromMap({
      'detect_faces': 'true',
      'limit': '1',
      'prediction_count': '1',
      'file': await MultipartFile.fromFile(filePath),
    });

    try {
      Response response = await _dio.post(
        recognizePath,
        data: formData,
        options: Options(
          headers: {
            'x-api-key': _storage.getApiKey(),
            'Content-Type': 'multipart/form-data',
          },
        ),
        cancelToken: _cancelToken,
      );

      if (response.statusCode == 200) {
        var data = response.data;
        RecognizeResponseModel recognized = RecognizeResponseModel.fromJson(data);

        return ApiResponse(data: recognized, error: null);
      }
      ErrorResponseModel errorResponseModel =
          ErrorResponseModel.fromJson(json.decode(response.data));

      return ApiResponse(data: null, error: errorResponseModel.message);
    } on TimeoutException catch (_) {
      return const ApiResponse(data: null, error: 'Request timeout');
    } on DioException catch (error) {
      return parseDioError(error);
    } catch (error, stack) {
      debugPrint(error.toString());
      debugPrint(stack.toString());
      return ApiResponse(data: null, error: 'Error in recognizeFilePath: $error');
    }
  }

  Future<ApiResponse> recognize(Uint8List fileBytes) async {
    // avoid multiple calls
    cancelOngoingRequests();
    _cancelToken = CancelToken();

    FormData formData = FormData.fromMap({
      'detect_faces': 'true',
      'limit': '1',
      'prediction_count': '1',
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: 'face_reco.jpg',
        contentType: DioMediaType.parse('image/jpeg'),
      ),
    });

    try {
      Response response = await _dio.post(
        recognizePath,
        data: formData,
        options: Options(
          headers: {
            'x-api-key': _storage.getApiKey(),
            'Content-Type': 'multipart/form-data',
          },
        ),
        cancelToken: _cancelToken,
      );

      if (response.statusCode == 200) {
        var data = response.data;
        RecognizeResponseModel recognized = RecognizeResponseModel.fromJson(data);

        return ApiResponse(data: recognized, error: null);
      }
      ErrorResponseModel errorResponseModel =
          ErrorResponseModel.fromJson(json.decode(response.data));

      return ApiResponse(data: null, error: errorResponseModel.message);
    } on TimeoutException catch (_) {
      return const ApiResponse(data: null, error: 'Request timeout');
    } on DioException catch (error) {
      return parseDioError(error);
    } catch (error, stack) {
      debugPrint(error.toString());
      debugPrint(stack.toString());
      return ApiResponse(data: null, error: 'Error in recognizeFace: $error');
    }
  }

  Future<ApiResponse> addSubject(String name) async {
    try {
      Map<String, dynamic> requestBody = {'subject': name};

      Response response = await _dio.post(
        subjectsPath,
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': _storage.getApiKey(),
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(data: name, error: null);
      }
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(response.data);
      return ApiResponse(data: null, error: errorResponseModel.message);
    } on TimeoutException catch (_) {
      return const ApiResponse(data: null, error: 'Request timeout');
    } on DioException catch (error) {
      return parseDioError(error);
    } catch (error, stack) {
      debugPrint(stack.toString());
      return ApiResponse(data: null, error: 'Error in addSubject: $error');
    }
  }

  Future<ApiResponse> deleteSubject(String name) async {
    try {
      Response response = await _dio.delete(
        '$subjectsPath/$name',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': _storage.getApiKey(),
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(data: name, error: null);
      }
      ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(response.data);
      return ApiResponse(data: null, error: errorResponseModel.message);
    } on TimeoutException catch (_) {
      return const ApiResponse(data: null, error: 'Request timeout');
    } on DioException catch (error) {
      return parseDioError(error);
    } catch (error, stack) {
      debugPrint(stack.toString());
      return ApiResponse(data: null, error: 'Error in deleteSubject: $error');
    }
  }

  Future<ApiResponse> callExternalApi() async {
    try {
      debugPrint('Calling external API');

      String apiURL = _storage.getExtApiURL();
      String apiMethod = _storage.getExtApiMethod().toLowerCase();
      Map<String, String> headers = _storage.getExtApiHeaders().trim().isEmpty
          ? {}
          : Map<String, String>.from(
              json.decode(_storage.getExtApiHeaders().trim()),
            );
      String body = _storage.getExtApiBody().trim().isEmpty
          ? ''
          : json.encode(json.decode(_storage.getExtApiBody().trim()));

      final Dio httpClient = Dio();

      Response response;

      switch (apiMethod) {
        case 'get':
          response = await httpClient.get(
            apiURL,
            options: Options(headers: headers),
          );
          break;
        case 'post':
          response = await httpClient.post(
            apiURL,
            data: body,
            options: Options(headers: headers),
          );
          break;
        case 'put':
          response = await httpClient.put(
            apiURL,
            data: body,
            options: Options(headers: headers),
          );
          break;
        case 'delete':
          response = await httpClient.delete(
            apiURL,
            options: Options(headers: headers),
          );
          break;
        default:
          throw UnsupportedError('Unsupported HTTP method: $apiMethod');
      }

      if (response.statusCode == 200) {
        debugPrint('External API call successful');
        return ApiResponse(data: response.data, error: null);
      }
      String message = response.data.toString();

      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        code: response.statusCode ?? -69,
        message: message,
      );

      return ApiResponse(data: null, error: errorResponseModel.message);
    } on TimeoutException catch (_) {
      return const ApiResponse(data: null, error: 'Request timeout');
    } on DioException catch (error) {
      return parseDioError(error);
    } catch (error, stack) {
      debugPrint(stack.toString());
      return ApiResponse(data: null, error: 'Error: $error');
    }
  }

  void cancelOngoingRequests() {
    if (_cancelToken.isCancelled == false) {
      _cancelToken.cancel('Request cancelled');
    }
    // _cancelToken = CancelToken();
  }

  ApiResponse parseDioError(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      return const ApiResponse(data: null, error: '');
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return const ApiResponse(data: null, error: 'Connection timeout');
    }
    if (error.response?.data != null) {
      try {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(jsonDecode(error.response!.toString()));
        return ApiResponse(data: null, error: errorResponseModel.message);
      } catch (_) {
        return ApiResponse(
          data: null,
          error: (error.error ?? 'Unknown error ${error.message ?? ''}').toString(),
        );
      }
    } else {
      return ApiResponse(
        data: null,
        error: (error.error ?? 'Unknown error ${error.message ?? ''}').toString(),
      );
    }
  }
}

class ApiResponse<T> {
  final T? data;
  final String? error;

  const ApiResponse({this.data, this.error});

  bool get hasData => data != null;

  bool get hasError => error != null;
}

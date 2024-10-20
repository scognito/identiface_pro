import 'dart:typed_data';

import 'package:face_detector/models/add_face_response_model.dart';
import 'package:face_detector/models/recognize_response_model.dart';
import 'package:face_detector/services/api_service.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import '../mocks.mocks.dart';

void main() {
  final locator = GetIt.instance;

  late MockApiService mockApiService;
  late MockDio mockDio;
  late MockStorageService mockStorageService;

  setUp(() {
    locator.reset();

    mockStorageService = MockStorageService();
    mockApiService = MockApiService();
    mockDio = MockDio();

    locator.registerSingleton<StorageService>(mockStorageService);
    locator.registerSingleton<ApiService>(mockApiService);
  });

  group('ApiService Tests', () {
    test('getSubjects returns subjects response on successful', () async {
      when(mockStorageService.getApiKey()).thenReturn('mock-api-key');
      when(mockApiService.getSubjects()).thenAnswer(
        (_) async => const ApiResponse(data: ['Subject1', 'Subject2']),
      );

      final response = await mockApiService.getSubjects();

      expect(response.hasData, true);
      expect(response.data, ['Subject1', 'Subject2']);
      expect(response.hasError, false);
    });

    test('addFace returns recognized face response on success', () async {
      final Uint8List fileBytes = Uint8List.fromList([0, 1, 2, 3, 4, 5]);
      final String name = 'Test Subject';

      final mockResponseData = {'image_id': '123', 'subject': name};

      when(mockStorageService.getApiKey()).thenReturn('mock-api-key');
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: mockResponseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/my/path'),
              ));
      when(mockApiService.addFace(any, any)).thenAnswer(
        (_) async => ApiResponse(
          data: AddFaceResponseModel.fromJson(mockResponseData),
          error: null,
        ),
      );

      final response = await mockApiService.addFace(name, fileBytes);

      expect(response.hasData, true);
      expect(response.data, isA<AddFaceResponseModel>());
      expect(response.error, null);
    });

    test('recognize returns recognized face response on success', () async {
      final Uint8List fileBytes = Uint8List.fromList([0, 1, 2, 3, 4, 5]);

      final mockResponseData = {
        'result': [
          {
            'box': {
              'probability': 0.98,
              'x_max': 100,
              'y_max': 150,
              'x_min': 50,
              'y_min': 75,
            },
            'subjects': [
              {'subject': 'Test Subject', 'similarity': 0.95},
            ],
          },
        ],
      };

      when(mockStorageService.getApiKey()).thenReturn('mock-api-key');
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: mockResponseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: 'recognizePath'),
              ));

      when(mockApiService.recognize(any)).thenAnswer(
        (_) async => ApiResponse(
          data: RecognizeResponseModel.fromJson(mockResponseData),
          error: null,
        ),
      );

      final response = await mockApiService.recognize(fileBytes);

      expect(response.hasData, true);
      expect(response.data, isA<RecognizeResponseModel>());
      expect(response.data!.result.first.box.probability, 0.98);
      expect(response.data!.result.first.subjects.first.subject, 'Test Subject');
      expect(response.data!.result.first.subjects.first.similarity, 0.95);
      expect(response.error, null);
    });

    test('addSubject returns subject name on success', () async {
      final String name = 'Test Subject';
      final Map<String, dynamic> requestBody = {'subject': name};

      when(mockStorageService.getApiKey()).thenReturn('mock-api-key');
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer(
        (_) async => Response(
          data: requestBody,
          statusCode: 201,
          requestOptions: RequestOptions(path: 'subjectsPath'),
        ),
      );

      when(mockApiService.addSubject(any)).thenAnswer(
        (_) async => ApiResponse(data: name, error: null),
      );

      final response = await mockApiService.addSubject(name);

      expect(response.hasData, true);
      expect(response.data, name);
      expect(response.error, null);
    });
  });

  test('delete returns subject name on success', () async {
    final String name = 'Test Subject';
    final Map<String, dynamic> requestBody = {'subject': name};

    when(mockStorageService.getApiKey()).thenReturn('mock-api-key');
    when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer(
      (_) async => Response(
        data: requestBody,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'subjectsPath'),
      ),
    );

    when(mockApiService.deleteSubject(any)).thenAnswer(
      (_) async => ApiResponse(data: name, error: null),
    );

    final response = await mockApiService.deleteSubject(name);

    expect(response.hasData, true);
    expect(response.data, name);
    expect(response.error, null);
  });
}

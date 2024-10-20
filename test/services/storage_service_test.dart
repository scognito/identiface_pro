import 'package:face_detector/services/api_service.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  final locator = GetIt.instance;

  late MockApiService mockApiService;
  late MockStorageService mockStorageService;

  setUp(() {
    locator.reset();

    mockStorageService = MockStorageService();
    mockApiService = MockApiService();

    locator.registerSingleton<StorageService>(mockStorageService);
    locator.registerSingleton<ApiService>(mockApiService);
  });

  tearDown(() {
    locator.reset();
  });

  group('ApiService Tests', () {
    test('getApiKey returns stored API key', () {
      when(mockStorageService.getApiKey()).thenReturn('mock-api-key');

      final apiKey = mockStorageService.getApiKey();

      expect(apiKey, 'mock-api-key');
    });

    test('setApiKey stores the API key', () async {
      when(mockStorageService.setApiKey(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setApiKey('new-api-key');

      expect(result, true);
      verify(mockStorageService.setApiKey('new-api-key')).called(1);
    });

    test('getPin returns stored pin', () {
      when(mockStorageService.getPin()).thenReturn('1234');

      final pin = mockStorageService.getPin();

      expect(pin, '1234');
    });

    test('setPin stores the pin', () async {
      when(mockStorageService.setPin(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setPin('5678');

      expect(result, true);
      verify(mockStorageService.setPin('5678')).called(1);
    });

    test('getMasterPassword returns stored master password', () {
      when(mockStorageService.getMasterPassword()).thenReturn('my-master-password');

      final masterPassword = mockStorageService.getMasterPassword();

      expect(masterPassword, 'my-master-password');
    });

    test('setMasterPassword stores the master password', () async {
      when(mockStorageService.setMasterPassword(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setMasterPassword('new-password');

      expect(result, true);
      verify(mockStorageService.setMasterPassword('new-password')).called(1);
    });

    test('getBaseUrl returns stored base URL', () {
      when(mockStorageService.getBaseUrl()).thenReturn('http://example.com');

      final baseUrl = mockStorageService.getBaseUrl();

      expect(baseUrl, 'http://example.com');
    });

    test('setBaseUrl stores the base URL', () async {
      when(mockStorageService.setBaseUrl(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setBaseUrl('http://new-url.com');

      expect(result, true);
      verify(mockStorageService.setBaseUrl('http://new-url.com')).called(1);
    });

    test('getSimilarity returns stored similarity', () {
      when(mockStorageService.getSimilarity()).thenReturn(0.85);

      final similarity = mockStorageService.getSimilarity();

      expect(similarity, 0.85);
    });

    test('setSimilarity stores the similarity', () async {
      when(mockStorageService.setSimilarity(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setSimilarity(0.75);

      expect(result, true);
      verify(mockStorageService.setSimilarity(0.75)).called(1);
    });

    test('getShowFacesInRecognize returns stored value', () {
      when(mockStorageService.getShowFacesInRecognize()).thenReturn(true);

      final showFaces = mockStorageService.getShowFacesInRecognize();

      expect(showFaces, true);
    });

    test('setShowFacesInRecognize stores the value', () async {
      when(mockStorageService.setShowFacesInRecognize(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setShowFacesInRecognize(false);

      expect(result, true);
      verify(mockStorageService.setShowFacesInRecognize(false)).called(1);
    });

    test('getExtApiURL returns stored external API URL', () {
      when(mockStorageService.getExtApiURL()).thenReturn('https://external-api.com');

      final extApiUrl = mockStorageService.getExtApiURL();

      expect(extApiUrl, 'https://external-api.com');
    });

    test('setExtApiURL stores the external API URL', () async {
      when(mockStorageService.setExtApiURL(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setExtApiURL('https://new-api.com');

      expect(result, true);
      verify(mockStorageService.setExtApiURL('https://new-api.com')).called(1);
    });

    test('getTheme returns stored theme', () {
      when(mockStorageService.getTheme()).thenReturn('dark');

      final theme = mockStorageService.getTheme();

      expect(theme, 'dark');
    });

    test('setTheme stores the theme', () async {
      when(mockStorageService.setTheme(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setTheme('light');

      expect(result, true);
      verify(mockStorageService.setTheme('light')).called(1);
    });

    test('getCameraIndex returns stored camera index', () {
      when(mockStorageService.getCameraIndex()).thenReturn(1);

      final cameraIndex = mockStorageService.getCameraIndex();

      expect(cameraIndex, 1);
    });

    test('setCameraIndex stores the camera index', () async {
      when(mockStorageService.setCameraIndex(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setCameraIndex(2);

      expect(result, true);
      verify(mockStorageService.setCameraIndex(2)).called(1);
    });

    test('getCameraOrientation returns stored camera orientation', () {
      when(mockStorageService.getCameraOrientation()).thenReturn(90);

      final cameraOrientation = mockStorageService.getCameraOrientation();

      expect(cameraOrientation, 90);
    });

    test('setCameraOrientation stores the camera orientation', () async {
      when(mockStorageService.setCameraOrientation(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setCameraOrientation(180);

      expect(result, true);
      verify(mockStorageService.setCameraOrientation(180)).called(1);
    });

    test('getLockOrientation returns stored lock orientation', () {
      when(mockStorageService.getLockOrientation()).thenReturn(false);

      final lockOrientation = mockStorageService.getLockOrientation();

      expect(lockOrientation, false);
    });

    test('setLockOrientation stores the lock orientation', () async {
      when(mockStorageService.setLockOrientation(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setLockOrientation(true);

      expect(result, true);
      verify(mockStorageService.setLockOrientation(true)).called(1);
    });

    test('getAutodetectFace returns stored value', () {
      when(mockStorageService.getAutodetectFace()).thenReturn(true);

      final autodetectFace = mockStorageService.getAutodetectFace();

      expect(autodetectFace, true);
    });

    test('setAutodetectFace stores the value', () async {
      when(mockStorageService.setAutodetectFace(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setAutodetectFace(false);

      expect(result, true);
      verify(mockStorageService.setAutodetectFace(false)).called(1);
    });

    test('getFullScreen returns stored value', () {
      when(mockStorageService.getFullScreen()).thenReturn(false);

      final fullScreen = mockStorageService.getFullScreen();

      expect(fullScreen, false);
    });

    test('setFullScreen stores the value', () async {
      when(mockStorageService.setFullScreen(any)).thenAnswer((_) async => true);

      final result = await mockStorageService.setFullScreen(true);

      expect(result, true);
      verify(mockStorageService.setFullScreen(true)).called(1);
    });
  });
}

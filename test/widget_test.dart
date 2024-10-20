import 'package:face_detector/config/constants.dart';
import 'package:face_detector/config/theme/material_like_theme.dart';
import 'package:face_detector/main.dart';
import 'package:face_detector/app_router.dart';
import 'package:face_detector/services/api_service.dart';
import 'package:face_detector/services/camera_service/camera_service.dart';
import 'package:face_detector/services/database_service.dart';
import 'package:face_detector/services/event_bus.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import 'mocks.mocks.dart';

void main() {
  final locator = GetIt.instance;

  late MockApiService mockApiService;
  late MockStorageService mockStorageService;
  late MockDatabaseService mockDatabaseService;
  late MockCameraService mockCameraService;
  late MockEventBus mockEventBus;
  late MockSettingsProvider mockSettingsProvider;

  void setUpMocks({required String masterPassword}) {
    when(mockStorageService.getMasterPassword()).thenReturn(masterPassword);
    when(mockStorageService.getTheme()).thenReturn(kThemeMaterial);
    when(mockStorageService.getShowFacesInRecognize()).thenReturn(kDefaultShowFacesInRecognize);
    when(mockStorageService.getCameraOrientation()).thenReturn(kDefaultCameraOrientation);
    when(mockStorageService.getAutodetectFace()).thenReturn(false);
    when(mockSettingsProvider.getTheme(any)).thenReturn(MaterialLikeTheme.theme());
    when(mockEventBus.on()).thenAnswer((_) => Stream<EventBusEvent>.empty());

    goRouter = AppRouter.getRouter();
  }

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();

    mockStorageService = MockStorageService();
    mockApiService = MockApiService();
    mockDatabaseService = MockDatabaseService();
    mockCameraService = MockCameraService();
    mockEventBus = MockEventBus();
    mockSettingsProvider = MockSettingsProvider();

    locator.registerSingleton<StorageService>(mockStorageService);
    locator.registerSingleton<ApiService>(mockApiService);
    locator.registerSingleton<DatabaseService>(mockDatabaseService);
    locator.registerSingleton<CameraService>(mockCameraService);
    locator.registerSingleton<EventBus>(mockEventBus);

    await locator.allReady();
  });

  tearDown(() {
    locator.reset();
  });

  group('App navigation tests', () {
    testWidgets(
      'initialLocation navigates to /menu when master password is empty',
      (tester) async {
        await tester.pumpAndSettle();
        setUpMocks(masterPassword: '');

        await tester.pumpWidget(MyApp());

        // wait for the showWarning(); to appear
        await tester.pumpAndSettle(const Duration(milliseconds: 600));

        expect(find.byKey(const Key(Routes.menu)), findsOneWidget);
      },
    );

    testWidgets(
      'initialLocation navigates to /recognize when master password exists',
      (tester) async {
        await tester.pumpAndSettle();
        setUpMocks(masterPassword: 'fake');

        await tester.pumpWidget(MyApp());
        await tester.pumpAndSettle();

        expect(find.byKey(const Key(Routes.recognize)), findsOneWidget);
      },
    );
  });
}

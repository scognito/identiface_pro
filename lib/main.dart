import 'package:face_detector/firebase_options.dart';
import 'package:face_detector/locator.dart';
import 'package:face_detector/providers/settings_provider.dart';
import 'package:face_detector/app_router.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/device_utils.dart';
import 'package:face_detector/utils/filesystem_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsProvider())],
      builder: (builderContext, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: goRouter,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme:
              Provider.of<SettingsProvider>(builderContext, listen: true).getTheme(builderContext),
        );
      },
    );
  }
}

Future<void> setupApp() async {
  setupLocators();
  await locator.allReady();
  await FileSystemUtils.createDirectories();

  // Firebase
  if (DeviceUtils.isMobile()) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Fullscreen for mobile
  if (DeviceUtils.isMobile()) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  // Fullscreen for Desktop
  if (DeviceUtils.isDesktop()) {
    await windowManager.ensureInitialized();

    bool isFullScreen = locator.get<StorageService>().getFullScreen();
    if (isFullScreen) {
      await windowManager.setFullScreen(true);
    }
  }

  await WakelockPlus.enable();
}

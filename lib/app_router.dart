import 'package:face_detector/locator.dart';
import 'package:face_detector/screens/crop_image/screen_crop_view.dart';
import 'package:face_detector/screens/menu/screen_menu_view.dart';
import 'package:face_detector/screens/recognize/screen_recognize_view.dart';
import 'package:face_detector/screens/settings/screen_settings_view.dart';
import 'package:face_detector/services/storage_service.dart';
import 'package:face_detector/utils/common_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter goRouter = AppRouter.getRouter();

// final goRouter2 = GoRouter(
//   initialLocation:
//       locator.get<StorageService>().getMasterPassword().isEmpty ? Routes.menu : Routes.recognize,
//   navigatorKey: _rootNavigatorKey,
//   debugLogDiagnostics: kDebugMode,
//   routes: [
//     GoRoute(
//       path: Routes.menu,
//       builder: (context, state) => const ScreenMenuView(),
//     ),
//     GoRoute(
//       path: Routes.recognize,
//       builder: (context, state) => const ScreenRecognizeView(),
//     ),
//     GoRoute(
//       path: Routes.settings,
//       builder: (context, state) => const ScreenSettingsView(),
//     ),
//     GoRoute(
//       path: Routes.crop,
//       pageBuilder: (context, state) => NoTransitionPage(
//         child: ScreenCropView(imagePath: state.extra as String),
//       ),
//     ),
//   ],
// );

class AppRouter {
  static GoRouter getRouter() {
    return GoRouter(
      initialLocation: _getInitialRoute(),
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: kDebugMode,
      routes: [
        GoRoute(
          path: Routes.menu,
          builder: (context, state) => const ScreenMenuView(),
        ),
        GoRoute(
          path: Routes.recognize,
          builder: (context, state) => const ScreenRecognizeView(),
        ),
        GoRoute(
          path: Routes.settings,
          builder: (context, state) => const ScreenSettingsView(),
        ),
        GoRoute(
          path: Routes.crop,
          pageBuilder: (context, state) => NoTransitionPage(
            child: ScreenCropView(imagePath: state.extra as String),
          ),
        ),
      ],
    );
  }

  static String _getInitialRoute() {
    final storage = locator.get<StorageService>();
    return (storage.getMasterPassword().isEmpty || !CommonUtils.isValidUrl(storage.getBaseUrl())
        ? Routes.menu
        : Routes.recognize);
  }
}

// class AppRouter {
//   // Private constructor
//   AppRouter._();
//
//   // Static variable to hold the single instance
//   static final AppRouter _instance = AppRouter._();
//
//   // Factory constructor to return the same instance
//   factory AppRouter() {
//     return _instance;
//   }
//
//   // Method to get the GoRouter
//   GoRouter getRouter() {
//     return GoRouter(
//       initialLocation: locator.get<StorageService>().getMasterPassword().isEmpty
//           ? Routes.menu
//           : Routes.recognize,
//       navigatorKey: _rootNavigatorKey,
//       debugLogDiagnostics: kDebugMode,
//       routes: [
//         GoRoute(
//           path: Routes.menu,
//           builder: (context, state) => const ScreenMenuView(),
//         ),
//         GoRoute(
//           path: Routes.recognize,
//           builder: (context, state) => const ScreenRecognizeView(),
//         ),
//         GoRoute(
//           path: Routes.settings,
//           builder: (context, state) => const ScreenSettingsView(),
//         ),
//         GoRoute(
//           path: Routes.crop,
//           pageBuilder: (context, state) => NoTransitionPage(
//             child: ScreenCropView(imagePath: state.extra as String),
//           ),
//         ),
//       ],
//     );
//   }
// }

class Routes {
  static const menu = '/menu';
  static const recognize = '/recognize';
  static const settings = '/settings';
  static const crop = '/crop';
}

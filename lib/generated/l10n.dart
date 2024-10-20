// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello World!`
  String get helloWorld {
    return Intl.message(
      'Hello World!',
      name: 'helloWorld',
      desc: '',
      args: [],
    );
  }

  /// `Password required`
  String get password_required {
    return Intl.message(
      'Password required',
      name: 'password_required',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get error_wrong_password {
    return Intl.message(
      'Incorrect password',
      name: 'error_wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `Create user`
  String get create_user {
    return Intl.message(
      'Create user',
      name: 'create_user',
      desc: '',
      args: [],
    );
  }

  /// `Edit {user}`
  String edit_user_name(String user) {
    return Intl.message(
      'Edit $user',
      name: 'edit_user_name',
      desc: '',
      args: [user],
    );
  }

  /// `Edit user`
  String get edit_user {
    return Intl.message(
      'Edit user',
      name: 'edit_user',
      desc: '',
      args: [],
    );
  }

  /// `Delete {user} ?`
  String delete_user_name(String user) {
    return Intl.message(
      'Delete $user ?',
      name: 'delete_user_name',
      desc: '',
      args: [user],
    );
  }

  /// `Delete`
  String get delete_user {
    return Intl.message(
      'Delete',
      name: 'delete_user',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Add new face for {user}?`
  String add_image_for_name_question(String user) {
    return Intl.message(
      'Add new face for $user?',
      name: 'add_image_for_name_question',
      desc: '',
      args: [user],
    );
  }

  /// `Add new face for {user}`
  String add_image_for_name(String user) {
    return Intl.message(
      'Add new face for $user',
      name: 'add_image_for_name',
      desc: '',
      args: [user],
    );
  }

  /// `Add new face for {user}`
  String add_image_for_user(String user) {
    return Intl.message(
      'Add new face for $user',
      name: 'add_image_for_user',
      desc: '',
      args: [user],
    );
  }

  /// `Add\nPicture`
  String get add_image {
    return Intl.message(
      'Add\nPicture',
      name: 'add_image',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing...`
  String get analyzing {
    return Intl.message(
      'Analyzing...',
      name: 'analyzing',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Changing camera`
  String get changing_camera {
    return Intl.message(
      'Changing camera',
      name: 'changing_camera',
      desc: '',
      args: [],
    );
  }

  /// `No camera found`
  String get no_camera_found {
    return Intl.message(
      'No camera found',
      name: 'no_camera_found',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `More info`
  String get more_info {
    return Intl.message(
      'More info',
      name: 'more_info',
      desc: '',
      args: [],
    );
  }

  /// `Tutorial`
  String get tutorial {
    return Intl.message(
      'Tutorial',
      name: 'tutorial',
      desc: '',
      args: [],
    );
  }

  /// `Tap to\nrecognize`
  String get tap_to_recognize {
    return Intl.message(
      'Tap to\nrecognize',
      name: 'tap_to_recognize',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to recognize`
  String get tap_here_recognize {
    return Intl.message(
      'Tap here to recognize',
      name: 'tap_here_recognize',
      desc: '',
      args: [],
    );
  }

  /// `Face added successfully`
  String get face_added {
    return Intl.message(
      'Face added successfully',
      name: 'face_added',
      desc: '',
      args: [],
    );
  }

  /// `Person added successfully`
  String get person_added {
    return Intl.message(
      'Person added successfully',
      name: 'person_added',
      desc: '',
      args: [],
    );
  }

  /// `Person deleted successfully`
  String get person_deleted {
    return Intl.message(
      'Person deleted successfully',
      name: 'person_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Invalid settings`
  String get invalid_settings {
    return Intl.message(
      'Invalid settings',
      name: 'invalid_settings',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get an_error_occurred {
    return Intl.message(
      'An error occurred',
      name: 'an_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `This app requires CompreFace to function.\n\nPlease ensure that CompreFace is installed and running before using this app.\n\nWithout it, the app will not operate as intended.\n\nFor more information and installation instructions, please select an option below`
  String get compreface_warning {
    return Intl.message(
      'This app requires CompreFace to function.\n\nPlease ensure that CompreFace is installed and running before using this app.\n\nWithout it, the app will not operate as intended.\n\nFor more information and installation instructions, please select an option below',
      name: 'compreface_warning',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `API Key`
  String get api_key {
    return Intl.message(
      'API Key',
      name: 'api_key',
      desc: '',
      args: [],
    );
  }

  /// `Base URL`
  String get base_url {
    return Intl.message(
      'Base URL',
      name: 'base_url',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Similarity Threshold`
  String get similarity_threshold {
    return Intl.message(
      'Similarity Threshold',
      name: 'similarity_threshold',
      desc: '',
      args: [],
    );
  }

  /// `Show faces during recognize`
  String get show_faces_in_recognize {
    return Intl.message(
      'Show faces during recognize',
      name: 'show_faces_in_recognize',
      desc: '',
      args: [],
    );
  }

  /// `Auto-detect faces`
  String get auto_detect_face {
    return Intl.message(
      'Auto-detect faces',
      name: 'auto_detect_face',
      desc: '',
      args: [],
    );
  }

  /// `External API call`
  String get external_api_call {
    return Intl.message(
      'External API call',
      name: 'external_api_call',
      desc: '',
      args: [],
    );
  }

  /// `Manage users`
  String get manage_users {
    return Intl.message(
      'Manage users',
      name: 'manage_users',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Invalid JSON`
  String get error_invalid_json {
    return Intl.message(
      'Invalid JSON',
      name: 'error_invalid_json',
      desc: '',
      args: [],
    );
  }

  /// `Mandatory field`
  String get error_mandatory_field {
    return Intl.message(
      'Mandatory field',
      name: 'error_mandatory_field',
      desc: '',
      args: [],
    );
  }

  /// `Invalid URL`
  String get error_invalid_url {
    return Intl.message(
      'Invalid URL',
      name: 'error_invalid_url',
      desc: '',
      args: [],
    );
  }

  /// `URL must start with http or https`
  String get error_url_scheme {
    return Intl.message(
      'URL must start with http or https',
      name: 'error_url_scheme',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get button_cancel {
    return Intl.message(
      'Cancel',
      name: 'button_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get button_save {
    return Intl.message(
      'Save',
      name: 'button_save',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get button_confirm {
    return Intl.message(
      'Confirm',
      name: 'button_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get button_retry {
    return Intl.message(
      'Retry',
      name: 'button_retry',
      desc: '',
      args: [],
    );
  }

  /// `Change camera`
  String get change_camera {
    return Intl.message(
      'Change camera',
      name: 'change_camera',
      desc: '',
      args: [],
    );
  }

  /// `Change orientation`
  String get change_orientation {
    return Intl.message(
      'Change orientation',
      name: 'change_orientation',
      desc: '',
      args: [],
    );
  }

  /// `Unlock camera orientation`
  String get lock_orientation {
    return Intl.message(
      'Unlock camera orientation',
      name: 'lock_orientation',
      desc: '',
      args: [],
    );
  }

  /// `Lock camera orientation`
  String get unlock_orientation {
    return Intl.message(
      'Lock camera orientation',
      name: 'unlock_orientation',
      desc: '',
      args: [],
    );
  }

  /// `Fullscreen`
  String get fullscreen {
    return Intl.message(
      'Fullscreen',
      name: 'fullscreen',
      desc: '',
      args: [],
    );
  }

  /// `If set, the API url is called once a face is succesfully recognized`
  String get popup_external_api_call {
    return Intl.message(
      'If set, the API url is called once a face is succesfully recognized',
      name: 'popup_external_api_call',
      desc: '',
      args: [],
    );
  }

  /// `If enabled, the recognition process starts as soon a face is visible on camera (uses more battery), otherwise it waits until the screen is touched`
  String get popup_autodetect {
    return Intl.message(
      'If enabled, the recognition process starts as soon a face is visible on camera (uses more battery), otherwise it waits until the screen is touched',
      name: 'popup_autodetect',
      desc: '',
      args: [],
    );
  }

  /// `If enabled, show random faces during recognition, otherwise a loading animation is shown`
  String get popup_show_faces {
    return Intl.message(
      'If enabled, show random faces during recognition, otherwise a loading animation is shown',
      name: 'popup_show_faces',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `New user`
  String get button_create_user {
    return Intl.message(
      'New user',
      name: 'button_create_user',
      desc: '',
      args: [],
    );
  }

  /// `Empty list`
  String get empty_list {
    return Intl.message(
      'Empty list',
      name: 'empty_list',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get button_close {
    return Intl.message(
      'Close',
      name: 'button_close',
      desc: '',
      args: [],
    );
  }

  /// `Error taking picture`
  String get error_taking_picture {
    return Intl.message(
      'Error taking picture',
      name: 'error_taking_picture',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

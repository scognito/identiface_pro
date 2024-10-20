// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(user) => "Add new face for ${user}";

  static String m1(user) => "Add new face for ${user}?";

  static String m2(user) => "Add new face for ${user}";

  static String m3(user) => "Delete ${user} ?";

  static String m4(user) => "Edit ${user}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_image": MessageLookupByLibrary.simpleMessage("Add\nPicture"),
        "add_image_for_name": m0,
        "add_image_for_name_question": m1,
        "add_image_for_user": m2,
        "an_error_occurred":
            MessageLookupByLibrary.simpleMessage("An error occurred"),
        "analyzing": MessageLookupByLibrary.simpleMessage("Analyzing..."),
        "api_key": MessageLookupByLibrary.simpleMessage("API Key"),
        "auto_detect_face":
            MessageLookupByLibrary.simpleMessage("Auto-detect faces"),
        "base_url": MessageLookupByLibrary.simpleMessage("Base URL"),
        "button_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "button_close": MessageLookupByLibrary.simpleMessage("Close"),
        "button_confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "button_create_user": MessageLookupByLibrary.simpleMessage("New user"),
        "button_retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "button_save": MessageLookupByLibrary.simpleMessage("Save"),
        "change_camera": MessageLookupByLibrary.simpleMessage("Change camera"),
        "change_orientation":
            MessageLookupByLibrary.simpleMessage("Change orientation"),
        "changing_camera":
            MessageLookupByLibrary.simpleMessage("Changing camera"),
        "compreface_warning": MessageLookupByLibrary.simpleMessage(
            "This app requires CompreFace to function.\n\nPlease ensure that CompreFace is installed and running before using this app.\n\nWithout it, the app will not operate as intended.\n\nFor more information and installation instructions, please select an option below"),
        "create_user": MessageLookupByLibrary.simpleMessage("Create user"),
        "delete_user": MessageLookupByLibrary.simpleMessage("Delete"),
        "delete_user_name": m3,
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "edit_user": MessageLookupByLibrary.simpleMessage("Edit user"),
        "edit_user_name": m4,
        "empty_list": MessageLookupByLibrary.simpleMessage("Empty list"),
        "error_invalid_json":
            MessageLookupByLibrary.simpleMessage("Invalid JSON"),
        "error_invalid_url":
            MessageLookupByLibrary.simpleMessage("Invalid URL"),
        "error_mandatory_field":
            MessageLookupByLibrary.simpleMessage("Mandatory field"),
        "error_taking_picture":
            MessageLookupByLibrary.simpleMessage("Error taking picture"),
        "error_url_scheme": MessageLookupByLibrary.simpleMessage(
            "URL must start with http or https"),
        "error_wrong_password":
            MessageLookupByLibrary.simpleMessage("Incorrect password"),
        "external_api_call":
            MessageLookupByLibrary.simpleMessage("External API call"),
        "face_added":
            MessageLookupByLibrary.simpleMessage("Face added successfully"),
        "fullscreen": MessageLookupByLibrary.simpleMessage("Fullscreen"),
        "helloWorld": MessageLookupByLibrary.simpleMessage("Hello World!"),
        "invalid_settings":
            MessageLookupByLibrary.simpleMessage("Invalid settings"),
        "lock_orientation":
            MessageLookupByLibrary.simpleMessage("Unlock camera orientation"),
        "manage_users": MessageLookupByLibrary.simpleMessage("Manage users"),
        "more_info": MessageLookupByLibrary.simpleMessage("More info"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "no_camera_found":
            MessageLookupByLibrary.simpleMessage("No camera found"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "password_required":
            MessageLookupByLibrary.simpleMessage("Password required"),
        "person_added":
            MessageLookupByLibrary.simpleMessage("Person added successfully"),
        "person_deleted":
            MessageLookupByLibrary.simpleMessage("Person deleted successfully"),
        "popup_autodetect": MessageLookupByLibrary.simpleMessage(
            "If enabled, the recognition process starts as soon a face is visible on camera (uses more battery), otherwise it waits until the screen is touched"),
        "popup_external_api_call": MessageLookupByLibrary.simpleMessage(
            "If set, the API url is called once a face is succesfully recognized"),
        "popup_show_faces": MessageLookupByLibrary.simpleMessage(
            "If enabled, show random faces during recognition, otherwise a loading animation is shown"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "show_faces_in_recognize":
            MessageLookupByLibrary.simpleMessage("Show faces during recognize"),
        "similarity_threshold":
            MessageLookupByLibrary.simpleMessage("Similarity Threshold"),
        "tap_here_recognize":
            MessageLookupByLibrary.simpleMessage("Tap here to recognize"),
        "tap_to_recognize":
            MessageLookupByLibrary.simpleMessage("Tap to\nrecognize"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "tutorial": MessageLookupByLibrary.simpleMessage("Tutorial"),
        "unlock_orientation":
            MessageLookupByLibrary.simpleMessage("Lock camera orientation"),
        "user": MessageLookupByLibrary.simpleMessage("User"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  static String m0(user) => "Aggiungi nuovo volto per ${user}";

  static String m1(user) => "Aggiungi nuovo volto per ${user}?";

  static String m2(user) => "Aggiungi alto volto";

  static String m3(user) => "Vuoi eliminare ${user}?";

  static String m4(user) => "Modifica ${user}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_image": MessageLookupByLibrary.simpleMessage("Aggiungi\nFoto"),
        "add_image_for_name": m0,
        "add_image_for_name_question": m1,
        "add_image_for_user": m2,
        "an_error_occurred":
            MessageLookupByLibrary.simpleMessage("Si è verificato un errore"),
        "analyzing": MessageLookupByLibrary.simpleMessage("Analisi..."),
        "api_key": MessageLookupByLibrary.simpleMessage("Chiave API"),
        "auto_detect_face": MessageLookupByLibrary.simpleMessage(
            "Riconoscimento automatico volti"),
        "base_url": MessageLookupByLibrary.simpleMessage("Base URL"),
        "button_cancel": MessageLookupByLibrary.simpleMessage("Annulla"),
        "button_close": MessageLookupByLibrary.simpleMessage("Chiudi"),
        "button_confirm": MessageLookupByLibrary.simpleMessage("Conferma"),
        "button_create_user":
            MessageLookupByLibrary.simpleMessage("Nuovo utente"),
        "button_retry": MessageLookupByLibrary.simpleMessage("Riprova"),
        "button_save": MessageLookupByLibrary.simpleMessage("Salva"),
        "change_camera":
            MessageLookupByLibrary.simpleMessage("Cambia fotocamera"),
        "change_orientation":
            MessageLookupByLibrary.simpleMessage("Ruota fotocamera"),
        "changing_camera":
            MessageLookupByLibrary.simpleMessage("Cambio fotocamera"),
        "compreface_warning": MessageLookupByLibrary.simpleMessage(
            "Questa app richiede CompreFace per funzionare.\n\nAssicurati che CompreFace sia installato e in esecuzione prima di utilizzare questa app.\n\nSenza di esso, l\'app non funzionerà come previsto.\n\nPer maggiori informazioni e istruzioni per l\'installazione, seleziona un\'opzione"),
        "create_user": MessageLookupByLibrary.simpleMessage("Crea utente"),
        "delete_user": MessageLookupByLibrary.simpleMessage("Elimina"),
        "delete_user_name": m3,
        "edit": MessageLookupByLibrary.simpleMessage("Modifica"),
        "edit_user": MessageLookupByLibrary.simpleMessage("Modifica utente"),
        "edit_user_name": m4,
        "empty_list": MessageLookupByLibrary.simpleMessage("Lista vuota"),
        "error_invalid_json":
            MessageLookupByLibrary.simpleMessage("JSON non valido"),
        "error_invalid_url":
            MessageLookupByLibrary.simpleMessage("Formato URL non valido"),
        "error_mandatory_field":
            MessageLookupByLibrary.simpleMessage("Campo obbligatorio"),
        "error_taking_picture":
            MessageLookupByLibrary.simpleMessage("Errore durante scatto foto"),
        "error_url_scheme": MessageLookupByLibrary.simpleMessage(
            "URL deve iniziare con http o https"),
        "error_wrong_password":
            MessageLookupByLibrary.simpleMessage("Password errata"),
        "external_api_call":
            MessageLookupByLibrary.simpleMessage("Chiamata API esterna"),
        "face_added":
            MessageLookupByLibrary.simpleMessage("Viso aggiunto con successo"),
        "fullscreen": MessageLookupByLibrary.simpleMessage("Schermo intero"),
        "helloWorld": MessageLookupByLibrary.simpleMessage("Hello World!"),
        "invalid_settings":
            MessageLookupByLibrary.simpleMessage("Impostazioni non valide"),
        "lock_orientation":
            MessageLookupByLibrary.simpleMessage("Blocca rotazione automatica"),
        "manage_users": MessageLookupByLibrary.simpleMessage("Gestione utenti"),
        "more_info": MessageLookupByLibrary.simpleMessage("Ulteriori info"),
        "name": MessageLookupByLibrary.simpleMessage("Nome"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "no_camera_found":
            MessageLookupByLibrary.simpleMessage("Nessuna fotocamera trovata!"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "password_required":
            MessageLookupByLibrary.simpleMessage("Password richiesta"),
        "person_added": MessageLookupByLibrary.simpleMessage(
            "Persona aggiunta con successo"),
        "person_deleted": MessageLookupByLibrary.simpleMessage(
            "Persona cancellata con successo"),
        "popup_autodetect": MessageLookupByLibrary.simpleMessage(
            "Se abilitato, il riconoscimento parte in automatico non appena la camera rileva un viso (consuma più batteria), altrimenti il riconoscimento parte solo quando si tocca lo schermo"),
        "popup_external_api_call": MessageLookupByLibrary.simpleMessage(
            "Se impostato, viene chiamata l\'API quando un viso viene riconosciuto correttamente"),
        "popup_show_faces": MessageLookupByLibrary.simpleMessage(
            "Se abilitato, mostra alcuni visi durante il riconoscimento, altrimenti verrà mostrato un\'animazione di caricamento"),
        "settings": MessageLookupByLibrary.simpleMessage("Impostazioni"),
        "show_faces_in_recognize": MessageLookupByLibrary.simpleMessage(
            "Mostra visi al riconoscimento"),
        "similarity_threshold":
            MessageLookupByLibrary.simpleMessage("Soglia di somiglianza"),
        "tap_here_recognize":
            MessageLookupByLibrary.simpleMessage("Tocca qui per scansionare"),
        "tap_to_recognize":
            MessageLookupByLibrary.simpleMessage("Tocca per\nscansionare"),
        "theme": MessageLookupByLibrary.simpleMessage("Tema"),
        "tutorial": MessageLookupByLibrary.simpleMessage("Tutorial"),
        "unlock_orientation": MessageLookupByLibrary.simpleMessage(
            "Sblocca rotazione automatica"),
        "user": MessageLookupByLibrary.simpleMessage("Utente"),
        "warning": MessageLookupByLibrary.simpleMessage("Attenzione"),
        "yes": MessageLookupByLibrary.simpleMessage("Sì")
      };
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/controllers/flashcard_database_controller_notifier.dart';
import 'package:intellistudy/controllers/flashcard_index_controller_notifier.dart';
import 'package:intellistudy/controllers/profile_status_controller.dart';
import 'package:intellistudy/controllers/search_database_controller_notifier.dart';
import 'package:intellistudy/controllers/search_text_controller_notifier.dart';
import 'package:intellistudy/controllers/text_controller_notifier.dart';
import '../controllers/auth_method_status_controller.dart';
import '../controllers/master_view_database_controller_notifier.dart';
import '../models/auth_model.dart';

// Search Page Providers

// final indexBox = Hive.box('flashcardIndexDataBase');

final searchIsLoadingStateProvider = StateProvider.autoDispose((ref) => false);
final searchIsValidStateProvider = StateProvider.autoDispose((ref) => true);
final searchAnswerTextProvider =
    StateNotifierProvider<SearchTextControllerNotifier, String?>(
        (ref) => SearchTextControllerNotifier(ref));
final searchFieldStateProvider =
    StateProvider.autoDispose(((ref) => TextEditingController()));
// Flashcard Create Page Providers

/// This is the provider that is used to access
/// the text controller notifier to generate the answer
final answerTextProvider =
    StateNotifierProvider<TextControllerNotifier, String?>(
  (ref) => TextControllerNotifier(ref),
);

/// This is the provider that is used to access
/// the circular progress indicator when the generated
/// response is loading
final isLoadingStateProvider = StateProvider.autoDispose((ref) => false);

/// This is the provider that is used to access
/// the valid prompt message when the user does not
/// enter a valid prompt
final isValidStateProvider = StateProvider.autoDispose((ref) => true);

/// This is the provider that is used to access
/// the search field text controller
final flashcardFieldStateProvider =
    StateProvider.autoDispose(((ref) => TextEditingController()));

// final responsesCountProvider = StateProvider.autoDispose((ref) => 3);

/// This is the provider that is used to access
/// the term text during editing
final termTextStateProvider = StateProvider<String>((ref) => '');

/// This is the provider that is used to access
/// the definition text during editing
final definitionTextStateProvider = StateProvider<String>((ref) => '');

final setTitleTextStateProvider =
    StateProvider.autoDispose((ref) => TextEditingController());
final setDescriptionTextStateProvider =
    StateProvider.autoDispose((ref) => TextEditingController());

// Hive Database Providers

/// This is the provider that is used to access
/// the database controller to store the responses
/// in the database and display them in the list view
final localFlashcardDBProvider =
    StateNotifierProvider<FlashCardDataBaseControllerNotifier, List>(
        ((ref) => FlashCardDataBaseControllerNotifier(ref)));

final localSearchDBProvider =
    StateNotifierProvider<SearchDataBaseControllerNotifier, List>(
        ((ref) => SearchDataBaseControllerNotifier(ref)));

final localMasterViewDBProvider =
    StateNotifierProvider<MasterViewDataBaseControllerNotifier, List>(
        ((ref) => MasterViewDataBaseControllerNotifier(ref)));

// Flashcard Providers

/// This is the provider that is used to access
/// the flashcard index to display the flashcards
/// in the list view
final flashcardIndexProvider = StateNotifierProvider.autoDispose(
    (ref) => FlashCardIndexControllerNotifier(ref));

/// Firebase Providers

/// This is the provider that is used to access
/// the firebase auth instance
// final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
//   return await Firebase.initializeApp();
// });

final authInstanceProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final fireStoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authProvider = Provider<AuthenticationModel>((ref) => AuthenticationModel(
      ref.watch(authInstanceProvider),
      ref,
      ref.watch(fireStoreProvider),
    ));

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authProvider).authStateChange;
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileStatusController, String>((ref) {
  return ProfileStatusController(ref);
});

/// Authentication Providers

/// This is the provider that is used to access
/// the text fields for the email and password
final firstIsLoadingStateProvider = StateProvider.autoDispose((ref) => false);
final emailTextProvider = StateProvider(((ref) => TextEditingController()));
final passwordTextProvider = StateProvider((ref) => TextEditingController());
final confirmPasswordTextProvider =
    StateProvider((ref) => TextEditingController());

final authStatusNotifierProvider =
    StateNotifierProvider<AuthMethodStatusController, Status>((ref) {
  return AuthMethodStatusController(ref);
});

/// FlashCard View Page Providers
final docLengthStateProvider = StateProvider.autoDispose((ref) => 2);

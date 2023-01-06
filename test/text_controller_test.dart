// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart';
// import 'package:http/testing.dart';
// import 'package:intellistudy/controllers/text_controller.dart';
// import 'package:mocktail/mocktail.dart';

// class MockTextController extends Mock implements TextController {}

// void main() {
//   dotenv.testLoad(fileInput: File('lib/.env').readAsStringSync());
//   // setUpAll() {
//   //   registerFallbackValue(MockTextController());
//   // }
//   late TextController textController;
//   textController = MockTextController();
//   final textControllerProvider =
//       StateNotifierProvider<TextController, String>((ref) => textController);
//   const promptText = 'This is a test prompt';
//   const answerText = 'This is a test answer';
//   test("Test the textControllerProvider reads accurate answer", () async {
//     // Set up the mock
//     when(() => textController.getText(promptText: promptText))
//         .thenAnswer((_) async => answerText);
//     final container = ProviderContainer();
//     addTearDown(container.dispose);

//     // Return the answer text
//     final result = await textController.getText(promptText: promptText);
//     expect(result, answerText);
//   });

//   group('getText API Response', () {
//     test("returns proper answer format when http response is successful",
//         () async {
//       final TextController textController = TextController();

//       final mockHTTPClient = MockClient((request) async {
//         // Create sample response of the HTTP call //
//         final response = {
//           "object": "text_completion",
//           "model": "text-davinci-003",
//           "choices": [
//             {
//               "text": "This is indeed a test.",
//               "index": 0,
//               "logprobs": null,
//               "finish_reason": "stop"
//             }
//           ],
//         };
//         return Response(jsonEncode(response), 200);
//       });
//     });
//   });
// }

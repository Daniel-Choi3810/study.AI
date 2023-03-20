import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../models/openai_request_model.dart';
import '../providers/providers.dart';

class TextControllerNotifier extends StateNotifier<String?> {
  // This is the controller for the text
  var url = Uri.parse(
      "https://api.openai.com/v1/chat/completions"); // This is the url that the post request is being sent to
  final _apiToken =
      dotenv.env['API_TOKEN']; // This is the api token located in the .env file
  final Ref ref; // This is the ref that is used to access the providers

  TextControllerNotifier(this.ref) : super('');

  String displayEnterPromptMessage() {
    // This is the default warning that is displayed if the user does not enter a prompt
    state = "Please enter a valid prompt";
    return state.toString();
  }

  Future<void> getText({required String promptText}) async {
    // This function is used to make the post request
    OpenAIRequestModel openAIRequestModel = OpenAIRequestModel(
      // This is the object that is used to make the post request
      // prompt: promptText,
      messages: [
        {"role": "user", "content": promptText}
      ],
      maxTokens: 2000,
      temperature: 1,
      topP: 0.5,
      n: 1,
      contentType: 'application/json',
      authorization: 'Bearer $_apiToken',
      model: 'gpt-3.5-turbo',
      url: url,
      apiToken: _apiToken!,
      // stop: '. ',
    );

    try {
      // This try catch block is used to make the post request and update the state of the app
      ref.read(isLoadingStateProvider.notifier).update((state) =>
          true); // This is used to update the loading progress of the app to true
      Response request = await openAIRequestModel
          .postRequest()
          .timeout(const Duration(seconds: 10), onTimeout: () {
        ref.read(isLoadingStateProvider.notifier).update((state) => false);
        return Response('error', 404);
      }); // This is the post request

      if (request.statusCode == 200) {
        ref.read(isLoadingStateProvider.notifier).update((state) => false);
        // if the request is successful, then the state is updated to the response
        state = await jsonDecode(utf8.decode(request.bodyBytes))['choices'][0]
                ['message']['content']
            .trim();
        print(state);
      } else {
        ref.read(isLoadingStateProvider.notifier).update((state) => false);
        // if the request is not successful, then the state is updated to the error
        state = "${request.statusCode} error, please try again";
      }
      ref.read(isLoadingStateProvider.notifier).update((state) => false);
    } catch (e) {
      ref.read(isLoadingStateProvider.notifier).update((state) => false);
      state = "$e, please reload and try again";
    }
  }
}

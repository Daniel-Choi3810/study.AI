import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:intellistudy/providers/providers.dart';
import 'dart:convert';
import 'package:intellistudy/models/openai_request_model.dart';

class SearchTextControllerNotifier extends StateNotifier<String?> {
  // This is the controller for the text
  var url = Uri.parse(
      "https://api.openai.com/v1/completions"); // This is the url that the post request is being sent to
  final _apiToken =
      dotenv.env['API_TOKEN']; // This is the api token located in the .env file
  final Ref ref; // This is the ref that is used to access the providers

  SearchTextControllerNotifier(this.ref) : super('');

  String displayEnterPromptMessage() {
    // This is the default warning that is displayed if the user does not enter a prompt
    state = "Please enter a valid prompt";
    return state.toString();
  }

  Future<void> getText({required String promptText}) async {
    // This function is used to make the post request
    OpenAIRequestModel openAIRequestModel = OpenAIRequestModel(
      // This is the object that is used to make the post request
      prompt: promptText,
      maxTokens: 20,
      temperature: 1,
      topP: 0.5,
      n: 1,
      stream: false,
      logprobs: null,
      contentType: 'application/json',
      authorization: 'Bearer $_apiToken',
      model: 'text-davinci-002',
      url: url,
      apiToken: _apiToken!,
      // stop: '. ',
    );

    try {
      // This try catch block is used to make the post request and update the state of the app
      ref.read(searchIsLoadingStateProvider.notifier).update((state) =>
          true); // This is used to update the loading progress of the app to true
      Response request = await openAIRequestModel
          .postRequest()
          .timeout(const Duration(seconds: 10), onTimeout: () {
        ref
            .read(searchIsLoadingStateProvider.notifier)
            .update((state) => false);
        return Response('error', 404);
      }); // This is the post request

      if (request.statusCode == 200) {
        ref
            .read(searchIsLoadingStateProvider.notifier)
            .update((state) => false);
        // if the request is successful, then the state is updated to the response
        state = await jsonDecode(utf8.decode(request.bodyBytes))['choices'][0]
                ['text']
            .trim();
        print(state);
      } else {
        // if the request is not successful, then the state is updated to the error
        state = "${request.statusCode} error, please try again";
      }
    } catch (e) {
      ref.read(searchIsLoadingStateProvider.notifier).update((state) => false);
      state = "$e, please reload and try again";
    }
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';
import 'dart:convert';
import 'package:intellistudy/models/openai_request_model.dart';

class SearchTextControllerNotifier extends StateNotifier<String?> {
  // This is the controller for the text
  var url = Uri.parse(
      "https://api.openai.com/v1/chat/completions"); // This is the url that the post request is being sent to
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
      // prompt: promptText,
      messages: [
        {"role": "user", "content": promptText}
      ],
      maxTokens: 2000,
      temperature: 0.5,
      topP: 1,
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
      ref.read(searchIsLoadingStateProvider.notifier).update((state) =>
          true); // This is used to update the loading progress of the app to true

      var response = await openAIRequestModel.postRequest();
      print("Response is: $response");
      if (response.statusCode == 200) {
        final result =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        print(result['choices'][0]['message']['content'].trim());
        ref
            .read(searchIsLoadingStateProvider.notifier)
            .update((state) => false);
        state = result['choices'][0]['message']['content'].trim();
        print("State is: $state");
      } else {
        ref
            .read(searchIsLoadingStateProvider.notifier)
            .update((state) => false);
        print(response.reasonPhrase);
        state = "${response.statusCode} error, please try again";
      }
    } catch (e) {
      ref.read(searchIsLoadingStateProvider.notifier).update((state) => false);
      state = "$e, please reload and try again";
    }
  }
}

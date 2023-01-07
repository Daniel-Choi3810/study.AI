import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:intellistudy/controllers/providers/text_controller_providers.dart';
import 'dart:convert';
import 'package:intellistudy/models/openai_request_model.dart';

class TextController extends StateNotifier<String> {
  // This is the controller for the text
  var url = Uri.parse(
      "https://api.openai.com/v1/completions"); // This is the url that the post request is being sent to
  final _apiToken =
      dotenv.env['API_TOKEN']; // This is the api token located in the .env file
  final Ref ref; // This is the ref that is used to access the providers

  TextController(this.ref) : super('');

  void enterPrompt() {
    // This is the default prompt that is displayed if the user does not enter a prompt
    state = "Please enter a valid prompt";
  }

  Future getText({required String promptText}) async {
    // This function is used to make the post request
    OpenAIRequestModel openAIRequestModel = OpenAIRequestModel(
      // This is the object that is used to make the post request
      prompt: promptText,
      maxTokens: 100,
      temperature: 0.6,
      topP: 0.5,
      n: 1,
      stream: false,
      logprobs: null,
      contentType: 'application/json',
      authorization: 'Bearer $_apiToken',
      model: 'text-davinci-002',
      url: url,
      apiToken: _apiToken!,
    );

    try {
      // This try catch block is used to make the post request and update the state of the app
      ref.read(isLoadingProvider.notifier).update((state) =>
          true); // This is used to update the loading progress of the app to true
      Stopwatch stopwatch = Stopwatch()..start();
      Response request =
          await openAIRequestModel.postRequest(); // This is the post request
      print('API Request executed in ${stopwatch.elapsed}');
      ref.read(isLoadingProvider.notifier).update((state) =>
          false); // This is used to update the loading progress of the app to false
      if (request.statusCode == 200) {
        // if the request is successful, then the state is updated to the response
        state = await jsonDecode(request.body)['choices'][0]['text'];
      } else {
        // if the request is not successful, then the state is updated to the error
        state = "${request.statusCode} error, please try again";
      }
    } catch (e) {
      // isLoading.value = false;
      // print(e.toString());
      state = e.toString();
    }
  }
}

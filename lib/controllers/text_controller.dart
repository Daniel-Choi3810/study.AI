import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intellistudy/controllers/providers/text_controller_providers.dart';
import 'dart:convert';
import 'package:intellistudy/models/openai_request_model.dart';

class TextController extends StateNotifier<String> {
  var url = Uri.parse("https://api.openai.com/v1/completions");
  final _apiToken = dotenv.env['API_TOKEN'];
  TextController(this.ref) : super('');
  final Ref ref;

  void enterPrompt() {
    state = "Please enter a valid prompt";
  }

  Future getText({required String promptText}) async {
    OpenAIRequestModel openAIRequestModel = OpenAIRequestModel(
      prompt: promptText,
      maxTokens: 100,
      temperature: 0.6,
      topP: 1,
      n: 1,
      stream: false,
      logprobs: null,
      contentType: 'application/json',
      authorization: 'Bearer $_apiToken',
      model: 'text-davinci-003',
      url: url,
      apiToken: _apiToken!,
    );

    try {
      ref.read(isLoadingProvider.notifier).update((state) => true);
      // print((ref.read(isLoadingProvider.notifier).state).toString());
      var request = await http.post(
        openAIRequestModel.url,
        headers: {
          'Content-Type': openAIRequestModel.contentType,
          'Authorization': openAIRequestModel.authorization,
        },
        body: jsonEncode(
          {
            "model": openAIRequestModel.model,
            "prompt": "${openAIRequestModel.prompt}\n \n",
            "max_tokens": openAIRequestModel.maxTokens,
            "temperature": openAIRequestModel.temperature,
            "top_p": openAIRequestModel.topP,
            "n": openAIRequestModel.n,
            "stream": openAIRequestModel.stream,
            "logprobs": openAIRequestModel.logprobs
          },
        ),
      );
      ref.read(isLoadingProvider.notifier).update((state) => false);
      if (request.statusCode == 200) {
        state = await jsonDecode(request.body)['choices'][0]['text'];
      } else {
        state = "${request.statusCode} error, please try again";
      }
    } catch (e) {
      // isLoading.value = false;
      // print(e.toString());
      state = e.toString();
    }
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intellistudy/models/openai_request_model.dart';

class TextController extends StateNotifier<String> {
  var url = Uri.parse("https://api.openai.com/v1/completions");
  final _apiToken = dotenv.env['API_TOKEN'];
  String ans = '';

  TextController() : super('');

  Future getText({required String promptText}) async {
    OpenAIRequestModel openAIRequestModel = OpenAIRequestModel(
      prompt: promptText,
      maxTokens: 100,
      temperature: 0,
      topP: 1,
      n: 1,
      stream: false,
      logprobs: null,
    );
    try {
      // isLoading.value = true;
      var request = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiToken',
        },
        body: jsonEncode(
          {
            "model": "text-davinci-003",
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
      if (request.statusCode == 200) {
        // isLoading.value = false;
        state = await jsonDecode(request.body)['choices'][0]['text'];
      } else {
        // isLoading.value = false;
        // print(jsonDecode(request.body));
        state = "${request.statusCode} error, please try again";
      }
    } catch (e) {
      // isLoading.value = false;
      // print(e.toString());
      state = e.toString();
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TextController extends StateNotifier<String> {
  var url = Uri.parse("https://api.openai.com/v1/completions");
  final _apiToken = "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";

  TextController() : super('');

  Future getText({required String promptText}) async {
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
            "prompt": "$promptText\n \n",
            "max_tokens": 100,
            "temperature": 0,
            "top_p": 1,
            "n": 1,
            "stream": false,
            "logprobs": null
          },
        ),
      );
      if (request.statusCode == 200) {
        // isLoading.value = false;
        state = jsonDecode(request.body)['choices'][0]['text'];
      } else {
        // isLoading.value = false;
        print(jsonDecode(request.body));
      }
    } catch (e) {
      // isLoading.value = false;
      print(e.toString());
    }
  }
}

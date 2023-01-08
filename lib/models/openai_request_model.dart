import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class OpenAIRequestModel {
  String prompt; // This is the prompt that the user enters
  int maxTokens; // This is the max number of tokens that the model can use
  double temperature; // This determines the randomness of the model response
  double topP;
  // String frequencyPenalty;
  // String presencePenalty;
  // String stop;
  dynamic n;
  bool stream;
  dynamic logprobs;
  String
      contentType; // This is the type of content that is being sent to the model
  String authorization; // This is the authorization token
  String
      model; // This is the model that is being used, currrently using davinci-003
  dynamic url; // This is the url that the post request is being sent to
  String apiToken; // This is the api token

  OpenAIRequestModel({
    // This is the constructor for the class
    required this.prompt,
    required this.maxTokens,
    required this.temperature,
    required this.topP,
    required this.n,
    required this.stream,
    required this.logprobs,
    required this.contentType,
    required this.authorization,
    required this.model,
    required this.url,
    required this.apiToken,
  });
// This map is used to convert the object to json, which is then used to make the post request
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prompt'] = prompt;
    data['max_tokens'] = maxTokens;
    data['temperature'] = temperature;
    data['top_p'] = topP;
    data['n'] = n;
    data['stream'] = stream;
    data['logprobs'] = logprobs;
    data['content_type'] = contentType;
    data['authorization'] = authorization;
    data['model'] = model;
    data['url'] = url;
    // data['frequency_penalty'] = frequencyPenalty;
    // data['presence_penalty'] = presencePenalty;
    // data['stop'] = stop;
    return data;
  }

  // This function is used to make and return the post request
  Future<Response> postRequest() async {
    var request = await http.post(
      url,
      headers: {
        'Content-Type': contentType,
        'Authorization': authorization,
      },
      body: jsonEncode(
        {
          "model": model,
          "prompt":
              "$prompt. Use UTF-8 encoding. \n \n", // TODO: Verify this work for encoding, and if not figure out how to encode UTF-8 ?
          "max_tokens": maxTokens,
          "temperature": temperature,
          "top_p": topP,
          "n": n,
          "stream": stream,
          "logprobs": logprobs
        },
      ),
    );
    return request;
  }
}

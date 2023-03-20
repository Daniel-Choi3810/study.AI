import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class OpenAIRequestModel {
  // String prompt; // This is the prompt that the user enters
  int maxTokens; // This is the max number of tokens that the model can use
  double temperature; // This determines the randomness of the model response
  double topP;
  // bool stream;
  // dynamic logprobs;
  // String frequencyPenalty;
  // String presencePenalty;
  // String stop;
  dynamic n;
  String
      contentType; // This is the type of content that is being sent to the model
  String authorization; // This is the authorization token
  String
      model; // This is the model that is being used, currrently using davinci-003
  dynamic url; // This is the url that the post request is being sent to
  String apiToken; // This is the api token
  List messages; // This is the message that is returned from the model

  // String stop; // This is the stop responses

  OpenAIRequestModel({
    // This is the constructor for the class
    // required this.prompt,
    required this.maxTokens,
    required this.temperature,
    required this.topP,
    required this.n,
    required this.contentType,
    required this.authorization,
    required this.model,
    required this.messages,
    // required this.stream,
    // required this.logprobs,
    required this.url,
    required this.apiToken,
    // required this.stop,
  });
// This map is used to convert the object to json, which is then used to make the post request
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['prompt'] = prompt;
    data['max_tokens'] = maxTokens;
    data['temperature'] = temperature;
    data['top_p'] = topP;
    data['n'] = n;
    data['content_type'] = contentType;
    data['authorization'] = authorization;
    data['model'] = model;
    data['url'] = url;
    data['messages'] = messages;
    // data['stream'] = stream;
    // data['logprobs'] = logprobs;
    // data['frequency_penalty'] = frequencyPenalty;
    // data['presence_penalty'] = presencePenalty;
    // data['stop'] = stop;
    return data;
  }

  // This function is used to make and return the post request
  Future<Response> postRequest() async {
    var headers = {
      'Content-Type': contentType,
      'Authorization': 'Bearer $apiToken'
    };
    var request = http.Request('POST', url);

    request.body = json.encode({
      "model": model,
      "messages": messages,
      "max_tokens": maxTokens,
      "temperature": temperature,
      "top_p": topP,
      "n": n
    });
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }
}

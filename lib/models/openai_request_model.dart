class OpenAIRequestModel {
  String prompt;
  int maxTokens;
  double temperature;
  double topP;
  // String frequencyPenalty;
  // String presencePenalty;
  // String stop;
  dynamic n;
  bool stream;
  dynamic logprobs;
  String contentType;
  String authorization;
  String model;
  dynamic url;
  String apiToken;

  OpenAIRequestModel({
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

    // data['frequency_penalty'] = frequencyPenalty;
    // data['presence_penalty'] = presencePenalty;
    // data['stop'] = stop;
    return data;
  }
}

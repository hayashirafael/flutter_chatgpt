import 'package:asp/asp.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';

import '../atoms/chat_atom.dart';
import '../common/constants.dart';

class ChatReducer extends Reducer {
  final chatGpt = ChatGpt(apiKey: apiKey);
  ChatReducer() {
    on(() => [sendMessageAction], sendMessage);
  }

  void sendMessage() async {
    final message = sendMessageAction.value;
    final request = CompletionRequest(
      stream: true,
      maxTokens: 4000,
      model: ChatGptModel.gpt35Turbo,
    );

    final stream = await chatGpt.createCompletionStream(request);
  }
}

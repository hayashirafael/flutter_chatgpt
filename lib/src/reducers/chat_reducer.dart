import 'dart:async';

import 'package:asp/asp.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter_chatgpt/src/models/chat_model.dart';

import '../atoms/chat_atom.dart';
import '../common/constants.dart';

class ChatReducer extends Reducer {
  final chatGpt = ChatGpt(apiKey: apiKey);
  ChatReducer() {
    on(() => [sendMessageAction], sendMessage);
  }

  void sendMessage() async {
    final message = sendMessageAction.value;
    if (message.isEmpty) {
      return;
    }
    chatLoading.value = true;

    chatsState.value.insert(0, ChatModel(text: message, isSender: true));
    chatsState.value.insert(0, ChatModel(text: '...', isSender: false));

    // forçar a chamada de reatividade
    chatsState();

    final request = CompletionRequest(
      stream: true,
      maxTokens: 4000,
      model: ChatGptModel.gpt35Turbo,
      messages: [Message(role: Role.user.name, content: message)],
    );

    final stream = await chatGpt.createChatCompletionStream(request);

    if (stream == null) {
      chatLoading.value = true;
      return;
    }

    final completer = Completer();
    final buffer = StringBuffer();

    final sup = stream.listen((event) {
      // streamMessageEnd = envia letra a letra
      if (event.streamMessageEnd) {
        chatLoading.value = false;
        completer.complete();
      }

      final buffedMessage = event.choices?.first.delta?.content ?? '';
      buffer.write(buffedMessage);
      chatsState.value[0] = chatsState.value[0].copyWith(text: buffer.toString());
      chatsState();
    });

    await completer.future;
    await sup.cancel();

    // state
  }
}

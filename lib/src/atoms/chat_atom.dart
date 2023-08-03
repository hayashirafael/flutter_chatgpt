// atoms
import 'package:asp/asp.dart';
import 'package:flutter_chatgpt/src/models/chat_model.dart';

final chatsState = Atom<List<ChatModel>>([]);

// actions
final sendMessageAction = Atom<String>('');

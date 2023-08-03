import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/src/models/chat_model.dart';
import 'package:flutter_chatgpt/src/widgets/chat_bubble.dart';
import 'package:flutter_chatgpt/src/widgets/chat_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final chatModels = [
    ChatModel(text: 'Teste 123'),
    ChatModel(text: 'Teste 123eqweqwe2321312', isSender: false),
    ChatModel(text: 'Teste i949412948239042', isSender: false),
  ];

  bool isLoading = false;

  void _sendMessage(String message) {
    setState(() {
      chatModels.insert(0, ChatModel(text: message));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter GPT'),
      ),
      body: Stack(
        children: [
          Align(
            child: Icon(
              Icons.rocket,
              size: 300,
              color: Colors.grey[200],
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            reverse: true,
            itemCount: chatModels.length,
            itemBuilder: (context, index) {
              return ChatBubble(model: chatModels[index]);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatField(
              onMessage: _sendMessage,
              sendEnable: !isLoading,
            ),
          ),
          if (isLoading)
            const Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(),
            )
        ],
      ),
    );
  }
}

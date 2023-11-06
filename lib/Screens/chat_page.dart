import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chat_sample_flutter/Controllers/socket_controller.dart';
import 'package:chat_sample_flutter/Widget/advanced_text_field.dart';
import 'package:chat_sample_flutter/Widget/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  SocketController? _socketController;
  late final TextEditingController _textEditingController;

  bool _isTextFieldHasContentYet = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _socketController = SocketController.get(context);

      _textEditingController.addListener(() {
        final _text = _textEditingController.text.trim();
        if (_text.isEmpty) {
          _socketController!.stopTyping();
          _isTextFieldHasContentYet = false;
        } else {
          if (_isTextFieldHasContentYet) return;
          _socketController!.typing();
          _isTextFieldHasContentYet = true;
        }
      });

      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _socketController!.unsubscribe();
    _textEditingController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textEditingController.text.isEmpty) return;
    final _message = Message(messageContent: _textEditingController.text);
    _socketController?.sendMessage(_message);
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            key: const ValueKey('appBar'),
            backgroundColor: Colors.grey.shade600,
            title: Text(_socketController?.subscription?.roomName ?? "-"),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                key: const ValueKey('logoutButton'),
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _socketController!.unsubscribe();
                  Navigator.pop(context);
                },
              )
            ],
          ),
          body: Container(
            color: Colors.grey.shade400,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: StreamBuilder<List<ChatEvent>>(
                        stream: _socketController?.watchEvents,
                        initialData: const [],
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          }
                          final _events = snapshot.data!;
                          if (_events.isEmpty) {
                            return const Center(
                                child: Text(
                              "Iniciando...",
                              style: TextStyle(
                                color: Color.fromARGB(255, 112, 111, 111),
                                fontWeight: FontWeight.bold,
                              ),
                              key: ValueKey('loadingText'),
                            ));
                          }
                          return ListView.separated(
                            reverse: true,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0)
                                    .add(
                              const EdgeInsets.only(bottom: 70.0),
                            ),
                            itemCount: _events.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 5.0),
                            itemBuilder: (context, index) {
                              final _event = _events[index];
                              if (_event is Message) {
                                return TextBubble(
                                  message: _event,
                                  type: _event.userName ==
                                          _socketController!
                                              .subscription!.userName
                                      ? BubbleType.sendBubble
                                      : BubbleType.receiverBubble,
                                  key: ValueKey(_event.messageContent),
                                );
                              } else if (_event is ChatUser) {
                                if (_event.userEvent == ChatUserEvent.left) {
                                  return Center(
                                      key: ValueKey(
                                        "${_event.userName} left",
                                      ),
                                      child: Text("${_event.userName} saiu"));
                                }
                                return Center(
                                    key: ValueKey(
                                      "${_event.userName} joined",
                                    ),
                                    child: Text("${_event.userName} entrou"));
                              } else if (_event is UserStartedTyping) {
                                return const UserTypingBubble(
                                  key: ValueKey('userTyping'),
                                );
                              }
                              return const SizedBox();
                            },
                          );
                        }),
                  ),
                  Positioned.fill(
                    top: null,
                    bottom: 0,
                    child: Container(
                      color: Colors.grey.shade600,
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: AdvancedTextField(
                              controller: _textEditingController,
                              hintText: "Escreva sua mensagem...",
                              onSubmitted: (_) => _sendMessage(),
                              key: const ValueKey('messageTextField'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            key: const ValueKey('sendButton'),
                            onPressed: () => _sendMessage(),
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

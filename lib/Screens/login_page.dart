import 'package:chat_sample_flutter/Controllers/socket_controller.dart';
import 'package:chat_sample_flutter/Models/subscription_models.dart';
import 'package:chat_sample_flutter/Screens/chat_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _userNameEditingController;
  late final TextEditingController _roomEditingController;

  @override
  void initState() {
    _userNameEditingController = TextEditingController();
    _roomEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SocketController.get(context)
        ..init()
        ..connect(
          onConnectionError: (data) {
            if (kDebugMode) {
              print(data);
            }
          },
        );
    });
    super.initState();
  }

  @override
  void dispose() {
    _userNameEditingController.dispose();
    _roomEditingController.dispose();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => SocketController.get(context).dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 30),
              child: Center(
                child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image.asset(
                      'assets/images/logo.png',
                      key: const ValueKey('logo'),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  key: const ValueKey('userNameTextField'),
                  controller: _userNameEditingController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Nome',
                    hintText: 'Informe o nome de usuário',
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  key: const ValueKey('roomTextField'),
                  controller: _roomEditingController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Sala',
                    hintText: 'Informe a sala',
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var subscription = Subscription(
                  roomName: _roomEditingController.text,
                  userName: _userNameEditingController.text,
                );
                SocketController.get(context).subscribe(
                  subscription,
                  onSubscribe: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ChatPage()));
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                foregroundColor: Colors.white,
              ),
              key: const ValueKey('loginButton'),
              child: const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}

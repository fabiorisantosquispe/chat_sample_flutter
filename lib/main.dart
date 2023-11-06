import 'package:chat_sample_flutter/Screens/login_page.dart';
import 'package:flutter/material.dart';

import 'package:chat_sample_flutter/Controllers/socket_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => SocketController(),
      child: const MaterialApp(
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

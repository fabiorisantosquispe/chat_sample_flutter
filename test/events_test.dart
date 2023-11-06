import 'package:chat_sample_flutter/Models/events.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ChatUser toString() method', () {
  const chatUser = ChatUser(userName: 'Alice', userEvent: ChatUserEvent.joined);
  expect(chatUser.toString(), 'ChatUser(userName: Alice, userEvent: ChatUserEvent.joined)');
});

  test('Message copyWith() method', () {
    const originalMessage = Message(messageContent: 'Hello', roomName: 'Room1', userName: 'Bob');
    final updatedMessage = originalMessage.copyWith(userName: 'Charlie');
    expect(updatedMessage.userName, 'Charlie');
    expect(updatedMessage.roomName, 'Room1');
  });

  test('Message toJson() method', () {
    const message = Message(messageContent: 'Testing', roomName: 'Room2', userName: 'Eve');
    final jsonMessage = message.toJson();
    expect(jsonMessage, '{"messageContent":"Testing","roomName":"Room2","userName":"Eve"}');
  });

  // Adicione mais testes conforme necessário.
}

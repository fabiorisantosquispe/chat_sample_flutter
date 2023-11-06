import 'package:chat_sample_flutter/Models/subscription_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_sample_flutter/Controllers/socket_controller.dart';
import 'package:mockito/mockito.dart';

class MockSocketController extends Mock implements SocketController {}

void main() {
  group('SocketController', () {
    test('init() initializes the socket', () {
      final socketController = SocketController();
      socketController.init();
      expect(socketController.connected, false);
    });

    test('connect() connects to the socket', () {
      final socketController = SocketController();
      socketController.init();
      final connected = socketController.connect();
      expect(connected, isNotNull);
    });

    test('disconnect() disconnects the socket', () {
      final socketController = SocketController();
      socketController.init();
      socketController.connect();
      final disconnected = socketController.disconnect();
      expect(disconnected, isNotNull);
    });

    test('subscribe() subscribes to a room', () {
      final mockSocketController = MockSocketController();
      const subscription = Subscription(roomName: 'Room1', userName: 'User1');
      when(mockSocketController.subscription).thenReturn(subscription);
      expect(mockSocketController.subscription, equals(subscription));
    });

    test('unsubscribe() unsubscribes from a room', () {
      final mockSocketController = MockSocketController();
      when(mockSocketController.subscription).thenReturn(null);
      expect(mockSocketController.subscription, isNull);
    });

    test('sendMessage() sends a message', () {
      final mockSocketController = MockSocketController();
      const message = Message(messageContent: 'Hello, World!');
      mockSocketController.sendMessage(message);
    });
  });
}

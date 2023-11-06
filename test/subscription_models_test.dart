import 'package:flutter_test/flutter_test.dart';
import 'package:chat_sample_flutter/Models/subscription_models.dart';

void main() {
  test('Subscription toString() method', () {
    const subscription = Subscription(roomName: 'Room1', userName: 'User1');
    expect(subscription.toString(), 'Subscription(roomName: Room1, userName: User1)');
  });
}

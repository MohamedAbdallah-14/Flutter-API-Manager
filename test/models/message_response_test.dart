
import 'package:test/test.dart';

import 'package:api_manager/src/models/message_response.dart';
import 'package:api_manager/src/models/mock/message_model_mock.dart';

void main() {
  test('''
MessageResponse model should be able to convert from and to json''', () async {
    // arrange
    final json = MessageModelMock.messageModelMock.toMap();
    // act
    final messageResponse = MessageResponse.fromMap(json);
    // assert
    expect(messageResponse, MessageModelMock.messageModelMock);
  });
}

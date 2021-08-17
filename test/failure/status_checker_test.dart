import 'package:api_manager/failures.dart';
import 'package:test/test.dart';


void main() {
  group('Status checker HTTPCodes', () {
    test('''
should return HTTPCode enum Success if called with 200''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker(200);
      // assert
      expect(code, HTTPCodes.success);
    });

    test('''
should return HTTPCode enum error if called with 400''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker(400);
      // assert
      expect(code, HTTPCodes.error);
    });

    test('''
should return HTTPCode enum invaildToken if called with 406''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker(406);
      // assert
      expect(code, HTTPCodes.invaildToken);
    });

    test('''
should return HTTPCode enum serviceNotAvailable if called with 500''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker(500);
      // assert
      expect(code, HTTPCodes.serviceNotAvailable);
    });

    test('''
should return HTTPCode enum unknown if called with 800''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker(800);
      // assert
      expect(code, HTTPCodes.unknown);
    });
  });

  group('Status checker ErrorStatus', () {
    test('''
should return ErrorStatus enum validationError if called with 400''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker.getErrorState(400);
      // assert
      expect(code, ErrorStatus.validationError);
    });

    test('''
should return ErrorStatus enum validationError if called with 401''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker.getErrorState(401);
      // assert
      expect(code, ErrorStatus.authorizationError);
    });

    test('''
should return ErrorStatus enum validationError if called with 403''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker.getErrorState(403);
      // assert
      expect(code, ErrorStatus.authenticationError);
    });

    test('''
should return ErrorStatus enum validationError if called with 410''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker.getErrorState(410);
      // assert
      expect(code, ErrorStatus.resourceNotFoundError);
    });
    test('''
should return ErrorStatus enum validationError if called with 400''', () async {
      // arrange
      final statusChecker = StatusChecker();
      // act
      final code = statusChecker.getErrorState(400);
      // assert
      expect(code, ErrorStatus.validationError);
    });
  });
}

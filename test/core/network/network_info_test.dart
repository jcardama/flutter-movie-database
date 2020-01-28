import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviedatabase/core/network/network_info.dart';
import 'dart:async';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('Should forward the call to DataConnectionChecker.hasConnection', () async {
      // arrange
      final hasConnectionFuture = Future.value(true);

      when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => hasConnectionFuture);
      // act
      final result = networkInfoImpl.isConnected;
      // assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, hasConnectionFuture);
    });
  });
}

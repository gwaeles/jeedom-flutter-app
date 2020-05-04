// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

//import 'package:flutter/material.dart';
//import 'package:flutter_app/services/jeedom/data_source/jeedom_repository.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/mockito.dart';

//class MockJeedomRepository extends Mock implements JeedomRepository {}

void main() {
//  LoginBloc loginBloc;
//  MockJeedomRepository jeedomRepository;
//
//  setUp(() {
//    userRepository = MockUserRepository();
//    authenticationBloc = MockAuthenticationBloc();
//    loginBloc = LoginBloc(
//      userRepository: userRepository,
//      authenticationBloc: authenticationBloc,
//    );
//  });
//
//  tearDown(() {
//    loginBloc?.close();
//    authenticationBloc?.close();
//  });
//
//  test('throws AssertionError when userRepository is null', () {
//    expect(
//          () => LoginBloc(
//        userRepository: null,
//        authenticationBloc: authenticationBloc,
//      ),
//      throwsAssertionError,
//    );
//  });
//
//  test('throws AssertionError when authenticationBloc is null', () {
//    expect(
//          () => LoginBloc(
//        userRepository: userRepository,
//        authenticationBloc: null,
//      ),
//      throwsAssertionError,
//    );
//  });
//
//  test('initial state is correct', () {
//    expect(LoginInitial(), loginBloc.initialState);
//  });
//
//  test('close does not emit new states', () {
//    expectLater(
//      loginBloc,
//      emitsInOrder([LoginInitial(), emitsDone]),
//    );
//    loginBloc.close();
//  });
//
//  group('LoginButtonPressed', () {
//    blocTest(
//      'emits [LoginLoading, LoginInitial] and token on success',
//      build: () async {
//        when(userRepository.authenticate(
//          username: 'valid.username',
//          password: 'valid.password',
//        )).thenAnswer((_) => Future.value('token'));
//        return loginBloc;
//      },
//      act: (bloc) => bloc.add(
//        LoginButtonPressed(
//          username: 'valid.username',
//          password: 'valid.password',
//        ),
//      ),
//      expect: [
//        LoginLoading(),
//        LoginInitial(),
//      ],
//      verify: (_) async {
//        verify(authenticationBloc.add(LoggedIn(token: 'token'))).called(1);
//      },
//    );
//
//    blocTest(
//      'emits [LoginLoading, LoginFailure] on failure',
//      build: () async {
//        when(userRepository.authenticate(
//          username: 'valid.username',
//          password: 'valid.password',
//        )).thenThrow(Exception('login-error'));
//        return loginBloc;
//      },
//      act: (bloc) => bloc.add(
//        LoginButtonPressed(
//          username: 'valid.username',
//          password: 'valid.password',
//        ),
//      ),
//      expect: [
//        LoginLoading(),
//        LoginFailure(error: 'Exception: login-error'),
//      ],
//      verify: (_) async {
//        verifyNever(authenticationBloc.add(any));
//      },
//    );
//  });
}

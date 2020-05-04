

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_event.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_state.dart';
import 'package:flutter_app/services/authentication/model/auth_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/testing.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:mockito/mockito.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AuthenticationBloc authenticationBloc;
  MockGoogleSignIn googleSignInMocked;
  MockFlutterSecureStorage storage;

  setUp(() {
    googleSignInMocked = MockGoogleSignIn();
    storage = MockFlutterSecureStorage();
    authenticationBloc = AuthenticationBloc(googleSignInMocked, storage);
  });

  tearDown(() {
    authenticationBloc?.dispose();
  });

  test('initial state is correct', () {
    expect(authenticationBloc.initialState, AuthenticationState.notAuthenticated());
  });

  test('Auth silently with valid stored infos', () {

    // GIVEN
    AuthInfo authInfo = AuthInfo(
        userId: 'uid',
        userName: 'John Doe',
        userEmail: 'john.doe@gmail.com',
        idToken: 'token',
        expirationTime: DateTime.now().add(Duration(hours: 1))
    );

    String serializedAuthInfo = jsonEncode(authInfo.toJson());

    final expectedResponse = [
      AuthenticationState.authenticating(),
      AuthenticationState.authenticated()
    ];

    when(storage.read(key: anyNamed('key'))).thenAnswer((_) => Future.value(serializedAuthInfo));

    expectLater(
      authenticationBloc.state,
      emitsInOrder(expectedResponse),
    );

    authenticationBloc.emitEvent(AuthenticationEventSignInSilently());
  });

  test('Auth silently fail', () {

    // GIVEN
    AuthInfo authInfo = AuthInfo(
        userId: 'uid',
        userName: 'John Doe',
        userEmail: 'john.doe@gmail.com',
        idToken: 'token',
        expirationTime: DateTime.now()
    );

    String serializedAuthInfo = jsonEncode(authInfo.toJson());

    final expectedResponse = [
      AuthenticationState.authenticating(),
      AuthenticationState.failure()
    ];

    when(storage.read(key: anyNamed('key'))).thenAnswer((_) => Future.value(serializedAuthInfo));
    when(storage.delete(key: anyNamed('key'))).thenAnswer((_) => Future.value());
    when(googleSignInMocked.signInSilently()).thenAnswer((_) => Future.value(null));

    expectLater(
      authenticationBloc.state,
      emitsInOrder(expectedResponse),
    );

    authenticationBloc.emitEvent(AuthenticationEventSignInSilently());
  });


  group('GoogleSignIn', () {
    const MethodChannel channelGoogle = MethodChannel(
      'plugins.flutter.io/google_sign_in',
    );
    const MethodChannel channelFirebase = MethodChannel(
      'plugins.flutter.io/firebase_auth',
    );

    const Map<String, String> kUserData = <String, String>{
      "email": "john.doe@gmail.com",
      "id": "8162538176523816253123",
      "photoUrl": "https://lh5.googleusercontent.com/photo.jpg",
      "displayName": "John Doe",
    };

    const Map<String, dynamic> kDefaultResponses = <String, dynamic>{
      'init': null,
      'signInSilently': kUserData,
      'signIn': kUserData,
      'signOut': null,
      'disconnect': null,
      'isSignedIn': true,
      'requestScopes': true,
      'getTokens': <dynamic, dynamic>{
        'idToken': '123',
        'accessToken': '456',
      },
    };

    const Map<String, dynamic> fbUserData = <String, dynamic>{
      "email": "john.doe@gmail.com",
      "uid": "8162538176523816253123",
      "photoUrl": "https://lh5.googleusercontent.com/photo.jpg",
      "displayName": "John Doe",
      'providerData': []
    };

    const Map<String, dynamic> fbDefaultResponses = <String, dynamic>{
      'signInWithCredential': <dynamic, dynamic>{
        'user': fbUserData,
        'additionalUserInfo': null
      },
      'getIdToken': <String, dynamic>{
        'token': 'ABC',
        'claims': kUserData,
        'expirationTimestamp': 0,
      }
    };

    final List<MethodCall> log = <MethodCall>[];
    Map<String, dynamic> responses;
    Map<String, dynamic> fbResponses;
    AuthenticationBloc authenticationBloc;
    GoogleSignIn googleSignIn;
    MockFlutterSecureStorage storage;

    setUp(() {
      responses = Map<String, dynamic>.from(kDefaultResponses);
      channelGoogle.setMockMethodCallHandler((MethodCall methodCall) {
        log.add(methodCall);
        final dynamic response = responses[methodCall.method];
        if (response != null && response is Exception) {
          return Future<dynamic>.error('$response');
        }
        return Future<dynamic>.value(response);
      });
      fbResponses = Map<String, dynamic>.from(fbDefaultResponses);
      channelFirebase.setMockMethodCallHandler((MethodCall methodCall) {
        log.add(methodCall);
        final dynamic response = fbResponses[methodCall.method];
        if (response != null && response is Exception) {
          return Future<dynamic>.error('$response');
        }
        return Future<dynamic>.value(response);
      });
      googleSignIn = GoogleSignIn();
      storage = MockFlutterSecureStorage();
      authenticationBloc = AuthenticationBloc(googleSignIn, storage);
      log.clear();
    });

    test('Auth silently with invalid stored infos', () {

      // GIVEN
      AuthInfo authInfo = AuthInfo(
          userId: '8162538176523816253123',
          userName: 'John Doe',
          userEmail: 'john.doe@gmail.com',
          idToken: 'token',
          expirationTime: DateTime.now()
      );

      String serializedAuthInfo = jsonEncode(authInfo.toJson());

      final expectedStateResponse = [
        AuthenticationState.authenticating(),
        AuthenticationState.authenticated()
      ];
      final expectedUserResponse = [
        authInfo
      ];

      when(storage.read(key: anyNamed('key'))).thenAnswer((_) => Future.value(serializedAuthInfo));
      when(storage.delete(key: anyNamed('key'))).thenAnswer((_) => Future.value());
      when(storage.write(key: anyNamed('key'), value: anyNamed('value'))).thenAnswer((_) => Future.value());

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedStateResponse),
      );
      expectLater(
        authenticationBloc.currentAuthInfo,
        emitsInOrder(expectedUserResponse),
      );

      authenticationBloc.emitEvent(AuthenticationEventSignInSilently());
    });

    test('signInSilently', () async {
      await googleSignIn.signInSilently();
      expect(googleSignIn.currentUser, isNotNull);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('signInSilently', arguments: null),
        ],
      );
    });

    test('signIn', () async {
      await googleSignIn.signIn();
      expect(googleSignIn.currentUser, isNotNull);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('signIn', arguments: null),
        ],
      );
    });

    test('signOut', () async {
      await googleSignIn.signOut();
      expect(googleSignIn.currentUser, isNull);
      expect(log, <Matcher>[
        isMethodCall('init', arguments: <String, dynamic>{
          'signInOption': 'SignInOption.standard',
          'scopes': <String>[],
          'hostedDomain': null,
        }),
        isMethodCall('signOut', arguments: null),
      ]);
    });

    test('disconnect; null response', () async {
      await googleSignIn.disconnect();
      expect(googleSignIn.currentUser, isNull);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('disconnect', arguments: null),
        ],
      );
    });

    test('disconnect; empty response as on iOS', () async {
      responses['disconnect'] = <String, dynamic>{};
      await googleSignIn.disconnect();
      expect(googleSignIn.currentUser, isNull);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('disconnect', arguments: null),
        ],
      );
    });

    test('isSignedIn', () async {
      final bool result = await googleSignIn.isSignedIn();
      expect(result, isTrue);
      expect(log, <Matcher>[
        isMethodCall('init', arguments: <String, dynamic>{
          'signInOption': 'SignInOption.standard',
          'scopes': <String>[],
          'hostedDomain': null,
        }),
        isMethodCall('isSignedIn', arguments: null),
      ]);
    });

    test('signIn works even if a previous call throws error in other zone',
            () async {
          responses['signInSilently'] = Exception('Not a user');
          await runZoned(() async {
            expect(await googleSignIn.signInSilently(), isNull);
          }, onError: (dynamic e, dynamic st) {});
          expect(await googleSignIn.signIn(), isNotNull);
          expect(
            log,
            <Matcher>[
              isMethodCall('init', arguments: <String, dynamic>{
                'signInOption': 'SignInOption.standard',
                'scopes': <String>[],
                'hostedDomain': null,
              }),
              isMethodCall('signInSilently', arguments: null),
              isMethodCall('signIn', arguments: null),
            ],
          );
        });

    test('concurrent calls of the same method trigger sign in once', () async {
      final List<Future<GoogleSignInAccount>> futures =
      <Future<GoogleSignInAccount>>[
        googleSignIn.signInSilently(),
        googleSignIn.signInSilently(),
      ];
      expect(futures.first, isNot(futures.last),
          reason: 'Must return new Future');
      final List<GoogleSignInAccount> users = await Future.wait(futures);
      expect(googleSignIn.currentUser, isNotNull);
      expect(users, <GoogleSignInAccount>[
        googleSignIn.currentUser,
        googleSignIn.currentUser
      ]);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('signInSilently', arguments: null),
        ],
      );
    });

    test('can sign in after previously failed attempt', () async {
      responses['signInSilently'] = Exception('Not a user');
      expect(await googleSignIn.signInSilently(), isNull);
      expect(await googleSignIn.signIn(), isNotNull);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('signInSilently', arguments: null),
          isMethodCall('signIn', arguments: null),
        ],
      );
    });

    test('concurrent calls of different signIn methods', () async {
      final List<Future<GoogleSignInAccount>> futures =
      <Future<GoogleSignInAccount>>[
        googleSignIn.signInSilently(),
        googleSignIn.signIn(),
      ];
      expect(futures.first, isNot(futures.last));
      final List<GoogleSignInAccount> users = await Future.wait(futures);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('signInSilently', arguments: null),
        ],
      );
      expect(users.first, users.last, reason: 'Must return the same user');
      expect(googleSignIn.currentUser, users.last);
    });

    test('can sign in after aborted flow', () async {
      responses['signIn'] = null;
      expect(await googleSignIn.signIn(), isNull);
      responses['signIn'] = kUserData;
      expect(await googleSignIn.signIn(), isNotNull);
    });

    test('signOut/disconnect methods always trigger native calls', () async {
      final List<Future<GoogleSignInAccount>> futures =
      <Future<GoogleSignInAccount>>[
        googleSignIn.signOut(),
        googleSignIn.signOut(),
        googleSignIn.disconnect(),
        googleSignIn.disconnect(),
      ];
      await Future.wait(futures);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('signOut', arguments: null),
          isMethodCall('signOut', arguments: null),
          isMethodCall('disconnect', arguments: null),
          isMethodCall('disconnect', arguments: null),
        ],
      );
    });

    test('queue of many concurrent calls', () async {
      final List<Future<GoogleSignInAccount>> futures =
      <Future<GoogleSignInAccount>>[
        googleSignIn.signInSilently(),
        googleSignIn.signOut(),
        googleSignIn.signIn(),
        googleSignIn.disconnect(),
      ];
      await Future.wait(futures);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('signInSilently', arguments: null),
          isMethodCall('signOut', arguments: null),
          isMethodCall('signIn', arguments: null),
          isMethodCall('disconnect', arguments: null),
        ],
      );
    });

    test('signInSilently suppresses errors by default', () async {
      channelGoogle.setMockMethodCallHandler((MethodCall methodCall) {
        throw "I am an error";
      });
      expect(await googleSignIn.signInSilently(), isNull); // should not throw
    });

    test('signInSilently forwards errors', () async {
      channelGoogle.setMockMethodCallHandler((MethodCall methodCall) {
        throw "I am an error";
      });
      expect(googleSignIn.signInSilently(suppressErrors: false),
          throwsA(isInstanceOf<PlatformException>()));
    });

    test('can sign in after init failed before', () async {
      int initCount = 0;
      channelGoogle.setMockMethodCallHandler((MethodCall methodCall) {
        if (methodCall.method == 'init') {
          initCount++;
          if (initCount == 1) {
            throw "First init fails";
          }
        }
        return Future<dynamic>.value(responses[methodCall.method]);
      });
      expect(googleSignIn.signIn(), throwsA(isInstanceOf<PlatformException>()));
      expect(await googleSignIn.signIn(), isNotNull);
    });

    test('created with standard factory uses correct options', () async {
      googleSignIn = GoogleSignIn.standard();

      await googleSignIn.signInSilently();
      expect(googleSignIn.currentUser, isNotNull);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('signInSilently', arguments: null),
        ],
      );
    });

    test('created with defaultGamesSignIn factory uses correct options',
            () async {
          googleSignIn = GoogleSignIn.games();

          await googleSignIn.signInSilently();
          expect(googleSignIn.currentUser, isNotNull);
          expect(
            log,
            <Matcher>[
              isMethodCall('init', arguments: <String, dynamic>{
                'signInOption': 'SignInOption.games',
                'scopes': <String>[],
                'hostedDomain': null,
              }),
              isMethodCall('signInSilently', arguments: null),
            ],
          );
        });

    test('authentication', () async {
      await googleSignIn.signIn();
      log.clear();

      final GoogleSignInAccount user = googleSignIn.currentUser;
      final GoogleSignInAuthentication auth = await user.authentication;

      expect(auth.accessToken, '456');
      expect(auth.idToken, '123');
      expect(
        log,
        <Matcher>[
          isMethodCall('getTokens', arguments: <String, dynamic>{
            'email': 'john.doe@gmail.com',
            'shouldRecoverAuth': true,
          }),
        ],
      );
    });

    test('requestScopes returns true once new scope is granted', () async {
      await googleSignIn.signIn();
      final result = await googleSignIn.requestScopes(['testScope']);

      expect(result, isTrue);
      expect(
        log,
        <Matcher>[
          isMethodCall('init', arguments: <String, dynamic>{
            'signInOption': 'SignInOption.standard',
            'scopes': <String>[],
            'hostedDomain': null,
          }),
          isMethodCall('signIn', arguments: null),
          isMethodCall('requestScopes', arguments: <String, dynamic>{
            'scopes': ['testScope'],
          }),
        ],
      );
    });
  });

  group('GoogleSignIn with fake backend', () {
    const FakeUser kUserData = FakeUser(
      id: "8162538176523816253123",
      displayName: "John Doe",
      email: "john.doe@gmail.com",
      photoUrl: "https://lh5.googleusercontent.com/photo.jpg",
    );

    GoogleSignIn googleSignIn;

    setUp(() {
      final MethodChannelGoogleSignIn platformInstance =
          GoogleSignInPlatform.instance;
      platformInstance.channel.setMockMethodCallHandler(
          (FakeSignInBackend()..user = kUserData).handleMethodCall);
      googleSignIn = GoogleSignIn();
    });

    test('user starts as null', () async {
      expect(googleSignIn.currentUser, isNull);
    });

    test('can sign in and sign out', () async {
      await googleSignIn.signIn();

      final GoogleSignInAccount user = googleSignIn.currentUser;

      expect(user.displayName, equals(kUserData.displayName));
      expect(user.email, equals(kUserData.email));
      expect(user.id, equals(kUserData.id));
      expect(user.photoUrl, equals(kUserData.photoUrl));

      await googleSignIn.disconnect();
      expect(googleSignIn.currentUser, isNull);
    });

    test('disconnect when signout already succeeds', () async {
      await googleSignIn.disconnect();
      expect(googleSignIn.currentUser, isNull);
    });
  });
}


import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';
import 'package:flutter_app/services/authentication/model/auth_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

///
/// Responsibility :
/// - Gateway to Firebase authentication service
///
class AuthenticationBloc
    extends BlocEventStateBase<AuthenticationEvent, AuthenticationState> {

  final GoogleSignIn googleSignIn;
  final FlutterSecureStorage storage;
  var doOnceSignin = false;

  BehaviorSubject<AuthInfo> _firebaseAuthInfoController = BehaviorSubject<AuthInfo>();
  Stream<AuthInfo> get currentAuthInfo => _firebaseAuthInfoController;

  AuthenticationBloc(this.googleSignIn, this.storage): super (
    initialState: AuthenticationState.notAuthenticated()
  );

  AuthenticationBloc.deft() : this(GoogleSignIn(), FlutterSecureStorage());

  @override
  Stream<AuthenticationState> eventHandler(
      AuthenticationEvent event, AuthenticationState currentState) async* {

    if (event is AuthenticationEventSignInSilently) {
      yield* signIn(true);
    }

    if (event is AuthenticationEventSignIn) {
      yield* signIn(false);
    }

    if (event is AuthenticationEventLogout){
      _firebaseAuthInfoController.add(null);

      await storage.delete(key: 'firebaseAuthInfo');

      yield AuthenticationState.notAuthenticated();

      googleSignIn.signOut();
    }
  }

  Stream<AuthenticationState> signIn(bool silently) async* {

    if (doOnceSignin) {
      return;
    }

    doOnceSignin = true;

    // Inform that we are proceeding with the authentication
    yield AuthenticationState.authenticating();

    String firebaseAuthInfo = await storage.read(key: 'firebaseAuthInfo');
    if (firebaseAuthInfo != null) {
      print('[GWA] Already signed in, checking validity...');

      try {
        AuthInfo authInfo = AuthInfo.fromJson(jsonDecode(firebaseAuthInfo));

        if (authInfo.expirationTime != null) {
          print('[GWA] signIn expirationTime=${authInfo.expirationTime}');

          if (authInfo.expirationTime.isAfter(DateTime.now())) {
            print('[GWA] Auth infos are valid.');
            _firebaseAuthInfoController.add(authInfo);

            String idToken = authInfo.idToken;
            if (idToken.length > 1000) {
              print("idToken: size=${idToken.length}");
              print("${idToken.substring(0, 1000)}");
              print("${idToken.substring(1000)}");
            } else {
              print("idToken: $idToken");
            }

            yield AuthenticationState.authenticated();

            doOnceSignin = false;
            return;
          } else {
            print('[GWA] Auth infos are expired.');
          }
        }
      }
      catch (e) {
        print(e);
      }
    }

    await storage.delete(key: 'firebaseAuthInfo');
    print('[GWA] Google Firebase signing in... ($silently)');
    FirebaseUser firebaseUser = await (
        silently ? googleSignIn.signInSilently() : googleSignIn.signIn()
    ).then((account) {
      return account == null ? null : signInWithGoogleAccount(account);
    });

    print('[GWA] Firebase user authenticated as ${firebaseUser?.displayName} (${firebaseUser?.email})');
    print('[GWA] Getting new idToken...');

    IdTokenResult idTokenResult = await firebaseUser?.getIdToken();

    if (firebaseUser != null && idTokenResult != null) {

      if (idTokenResult != null) {
        String idToken = idTokenResult.token;
        if (idToken.length > 1000) {
          print("idToken: size=${idToken.length}");
          print("${idToken.substring(0, 1000)}");
          print("${idToken.substring(1000)}");
        } else {
          print("idToken: $idToken");
        }
      }

      print('[GWA] New token received, storing infos...');

      AuthInfo authInfo = AuthInfo(
          userId: firebaseUser.uid,
          userName: firebaseUser.displayName,
          userEmail: firebaseUser.email,
          idToken: idTokenResult.token,
          expirationTime: idTokenResult.expirationTime
      );

      await storage.write(
          key: 'firebaseAuthInfo',
          value: jsonEncode(authInfo.toJson())
      );

      print('[GWA] Authenticated');

      _firebaseAuthInfoController.add(authInfo);

      // Inform that we have successfuly authenticated, or not
      yield AuthenticationState.authenticated();
    } else {
      yield AuthenticationState.failure();
    }

    doOnceSignin = false;
  }

  Future<FirebaseUser> signInWithGoogleAccount(GoogleSignInAccount googleSignInAccount) async {

    return googleSignInAccount.authentication
      .then((googleSignInAuthentication) {

        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        return FirebaseAuth.instance.signInWithCredential(credential)
          .then((authResult) {

            return authResult.user;
          });
      });
  }
}

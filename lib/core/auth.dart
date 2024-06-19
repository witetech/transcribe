// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  Auth({
    required GoogleSignIn googleSignIn,
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _googleSignIn = googleSignIn,
        _firebaseAuth = firebaseAuth;

  Future<bool> get isSignedIn async {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? auth = await googleUser?.authentication;
    await _firebaseAuth.signInWithCredential(
      GoogleAuthProvider.credential(
        accessToken: auth?.accessToken,
        idToken: auth?.idToken,
      ),
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

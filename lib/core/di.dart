// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Project imports:
import 'package:transcribe/core/auth.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  getIt.registerSingleton(Auth(
    googleSignIn: GoogleSignIn(),
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ));
}

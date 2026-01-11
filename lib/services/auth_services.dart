import 'package:firebase_auth/firebase_auth.dart';
// this is where value notifier came from 

// the value notifier will hold an instance of AuthService


class AuthService {
  // this is a singleton instance of FirebaseAuth and points to the current auth state
  // and if it changes the stream will emit new values
  // and the firebaseAuth will be changed 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  // _auth.currentUser is FirebaseAuth’s in-memory representation of thr result of the last sign-in operation
  // it will be null if no user is signed in

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    //  it returns the user object signed in
    return result.user;
  }

  // Register with email and password
  Future<User?> register({
    required String email,
    required String password,
  }) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }
// the error handling will be done in the UI layer
  // Sign out
  Future<void> signOut() async {
    
      await _auth.signOut();
    }



  }

 

// Right at app startup, 
//currentUser might be null for a moment until 
//Firebase finishes restoring state
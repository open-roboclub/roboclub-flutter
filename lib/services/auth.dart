import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:roboclub_flutter/models/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final Firestore _firestore = Firestore.instance;

class AuthService {
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);

    Map<String, dynamic> _tempUser;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (currentUser == null) {
      if (user != null) {
        _tempUser = {
          'name': user.displayName,
          'email': user.email,
          'profileImageUrl': user.photoUrl,
          'about': "",
          'batch': "",
          'contact': "",
          'cvLink': "",
          'fbId': "",
          'instaId': "",
          'interests': "",
          'isAdmin': false,
          'isMember': false,
          'linkedinId': "",
          'position': "N/A",
        };
        _firestore.collection('/users').document(user.uid).setData(_tempUser);
      }
    } else {
      await _firestore
          .collection('/users')
          .document(currentUser.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          _tempUser = snapshot.data;
        } else {
          print("User Data doesn't exist in firestore!");
        }
      });
    }
    // Only taking the first part of the name, i.e., First Name
    // if (name.contains(" ")) {
    //   name = name.substring(0, name.indexOf(" "));
    // }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return User.fromMap(_tempUser);
  }

  Future<User> getCurrentUser() async {
    Map<String, dynamic> _tempUser;
    final FirebaseUser currentUser = await _auth.currentUser();
    if (currentUser == null) {
      return User();
    } else {
      await _firestore
          .collection('/users')
          .document(currentUser.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          _tempUser = snapshot.data;
        } else {
          print("User Data doesn't exist in firestore!");
        }
      });
    }
    // Only taking the first part of the name, i.e., First Name
    // if (name.contains(" ")) {
    //   name = name.substring(0, name.indexOf(" "));
    // }
    return User.fromMap(_tempUser);
  }

  Future signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}

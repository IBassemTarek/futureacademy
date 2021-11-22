import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futureacademy/Models/user.dart';
import 'package:futureacademy/services/students_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel userFromFirebaseUser(user) {
    return user != null ? UserModel(id: user.uid) : UserModel(id: "null");
  }

  Stream<UserModel> get user {
    return _auth.authStateChanges().map(userFromFirebaseUser);
  }

  Future signIn(emailSignIn, passwordSignIn) async {
    var authResult = await _auth.signInWithEmailAndPassword(
        email: emailSignIn, password: passwordSignIn);
    return authResult.user;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future signUp(
      {required String emailSignIn,
      required String passwordSignIn,
      required String studentName,
      required int studentAge,
      required String studentNumber,
      required String studentGroupId,
      required String studentAddress,
      required BuildContext context}) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: emailSignIn, password: passwordSignIn);
      if (authResult.user != null) {
        UserModel user = userFromFirebaseUser(authResult.user);
        StudentsDataBaseServices().initStudentInfo(
          address: studentAddress,
          age: studentAge,
          uid: user.id,
          attHistory: [],
          currentMonthAtt: 0,
          evaluation: 0,
          group: studentGroupId,
          mobileNumber: studentNumber,
          name: studentName,
          notes: [],
          context: context,
        );

        return user.id;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed1"),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      }
    }
  }

  Future deleteUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      User user = _auth.currentUser!;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);

      UserCredential result =
          await user.reauthenticateWithCredential(credentials);

      await StudentsDataBaseServices().deleteUserData(uid: user.uid);
      await result.user?.delete();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return false;
    }
  }
}

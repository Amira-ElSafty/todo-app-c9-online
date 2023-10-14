import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_online/register/register_navigator.dart';

class RegisterScreenViewModel extends ChangeNotifier{
  ///todo: hold data - handle logic
  late RegisterNavigator navigator ;
  void register(String email , String password) async{
    /// show loading
    navigator.showMyLoading();
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      /// hide loading
     navigator.hideMyLoading();
      /// show message
      navigator.showMyMessage('Register Succuessfully');
    } on FirebaseAuthException catch (e) {
      /// hide loading
      /// show message (error)
      String errorMessage = 'Something went wrong';
      if (e.code == 'weak-password') {
        navigator.hideMyLoading();
        navigator.showMyMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        navigator.hideMyLoading();
        navigator.showMyMessage('The account already exists for that email.');
      }
    } catch (e) {
      navigator.hideMyLoading();
      navigator.showMyMessage(e.toString());
    }
  }
}
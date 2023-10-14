import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_online/login/login_navigator.dart';

class LoginScreenViewModel extends ChangeNotifier{
  //todo: hold data - handle logic
  var emailController = TextEditingController(text: 'amira10@route.com');
  var passwordController = TextEditingController(text: '123456');
  var formKey = GlobalKey<FormState>();

  late LoginNavigator navigator ;
  void login()async{
    /// register
    if(formKey.currentState?.validate() == true){
      navigator.showMyLoading();
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
        navigator.hideMyLoading();
        navigator.showMyMessage('Login Succuessfully');
        // var user = await FirebaseUtils.readUserFromFireStore(credential.user?.uid??'');
        // if(user == null){
        //   /// user authenticated but not found in db.
        //   return ;
        // }
        // var authProvider = Provider.of<AuthProvider>(context,listen: false);
        // authProvider.updateUser(user);
        // DialogUtils.hideLoading(context);
        // DialogUtils.showMessage(context, 'Login Succuessfully',
        //     title: 'Success',
        //     posActionName: 'Ok',
        //     posAction: (){
        //       Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        //     }
        // );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          navigator.hideMyLoading();
          navigator.showMyMessage(
              'No user found for that email or Wrong password provided for that user');
        }
      }catch(e){
        navigator.hideMyLoading();
        navigator.showMyMessage(
            e.toString());
      }
    }

  }
}
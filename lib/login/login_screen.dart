import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_online/components/custom_text_form_field.dart';
import 'package:flutter_app_todo_c9_online/dialog_utils.dart';
import 'package:flutter_app_todo_c9_online/firebase_utils.dart';
import 'package:flutter_app_todo_c9_online/home/home_screen.dart';
import 'package:flutter_app_todo_c9_online/providers/auth_provider.dart';
import 'package:flutter_app_todo_c9_online/register/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController(text: 'amira1@route.com');

  var passwordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/main_background.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  CustomTextFormField(
                    label: 'Email Address',
                    controller: emailController,
                    myValidator: (text){
                      if(text == null || text.trim().isEmpty){
                        return 'Please enter email Address';
                      }
                      bool emailValid =
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if(!emailValid){
                        return 'Please enter valid email';
                      }
                      return null ;
                    },
                  ),
                  CustomTextFormField(
                    label: 'Password',
                    controller: passwordController,
                    isPassword: true,
                    keyboardType: TextInputType.number,
                    myValidator: (text){
                      if(text == null || text.trim().isEmpty){
                        return 'Please enter Password';
                      }
                      if(text.length < 6){
                        return 'Password should be at least 6 chars.';
                      }
                      return null ;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10)
                      ),
                        onPressed: (){
                        login();
                        },
                        child: Text('Login',
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(onPressed: (){
                        Navigator.of(context).pushNamed(RegisterScreen.routeName);
                      }, child: Text('SignUp',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).primaryColor
                          )
                      ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login() async{
    if(formKey.currentState?.validate() == true){
      /// register
      DialogUtils.showLoading(context, 'Loading...');
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
       var user = await FirebaseUtils.readUserFromFireStore(credential.user?.uid??'');
        if(user == null){
         /// user authenticated but not found in db.
         return ;
       }
        var authProvider = Provider.of<AuthProvider>(context,listen: false);
        authProvider.updateUser(user);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Login Succuessfully',
            title: 'Success',
            posActionName: 'Ok',
            posAction: (){
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            }
        );
      } on FirebaseAuthException catch (e) {
        DialogUtils.hideLoading(context);
        if (e.code == 'user-not-found') {
          print('in if');
          DialogUtils.hideLoading(context);
          print('after show message');
          DialogUtils.showMessage(context, 'No user found for that email.');
          print('No user found for that email.');
        }
        else if (e.code == 'wrong-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, 'Wrong password provided for that user..');
        }
      }catch(e){
        print('error:${e.toString()}');
        DialogUtils.hideLoading(context);
        print('after hide loading');
        DialogUtils.showMessage(context, e.toString());
        print('after show message');
      }
    }
  }
}

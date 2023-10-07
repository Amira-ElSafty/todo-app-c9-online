import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_online/components/custom_text_form_field.dart';
import 'package:flutter_app_todo_c9_online/dialog_utils.dart';
import 'package:flutter_app_todo_c9_online/firebase_utils.dart';
import 'package:flutter_app_todo_c9_online/home/home_screen.dart';
import 'package:flutter_app_todo_c9_online/login/login_screen.dart';
import 'package:flutter_app_todo_c9_online/model/my_user.dart';
import 'package:flutter_app_todo_c9_online/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

}
class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController(text: 'Amira');

  var emailController = TextEditingController(text: 'amira2@route.com');

  var passwordController = TextEditingController(text: '123456');

  var confirmationPasswordController = TextEditingController(text: '123456');

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
                    label: 'User Name',
                    controller: nameController,
                    myValidator: (text){
                      if(text == null || text.trim().isEmpty){
                        return 'Please enter userName';
                      }
                      return null ;
                    },
                  ),
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
                  CustomTextFormField(
                    label: 'Confirmation Password',
                    controller: confirmationPasswordController,
                    isPassword: true,
                    keyboardType: TextInputType.number,
                    myValidator: (text){
                      if(text == null || text.trim().isEmpty){
                        return 'Please enter ConfirmationPassword';
                      }
                      if(text != passwordController.text){
                        return "password doesn't match";
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
                        register();
                        },
                        child: Text('Register',
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.1,),

                  TextButton(onPressed: (){
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                  }, child: Text('Already have an account',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColor
                      )
                  ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void register() async{
    if(formKey.currentState?.validate() == true){
      /// register
      /// show loading
      DialogUtils.showLoading(context, 'Loading...');
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text
        );
        var authProvider = Provider.of<AuthProvider>(context,listen: false);
        authProvider.updateUser(myUser);
        await FirebaseUtils.addUserToFireStore(myUser);

        /// hide loading
        DialogUtils.hideLoading(context);
        /// show message
        DialogUtils.showMessage(context, 'Register Succuessfully',
          title: 'Success',
          posActionName: 'Ok',
          posAction: (){
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          }
        );
      } on FirebaseAuthException catch (e) {
        /// hide loading
        /// show message (error)
        String errorMessage = 'Something went wrong';
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          errorMessage = 'The password provided is too weak.';
          DialogUtils.showMessage(context, errorMessage);
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          errorMessage = 'The account already exists for that email.';
          DialogUtils.showMessage(context,
            'The account already exists for that email.');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, e.toString());
      }
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_online/components/custom_text_form_field.dart';
import 'package:flutter_app_todo_c9_online/dialog_utils.dart';
import 'package:flutter_app_todo_c9_online/firebase_utils.dart';
import 'package:flutter_app_todo_c9_online/home/home_screen.dart';
import 'package:flutter_app_todo_c9_online/login/login_screen.dart';
import 'package:flutter_app_todo_c9_online/model/my_user.dart';
import 'package:flutter_app_todo_c9_online/providers/auth_provider.dart';
import 'package:flutter_app_todo_c9_online/register/register_navigator.dart';
import 'package:flutter_app_todo_c9_online/register/register_screen_view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

}
class _RegisterScreenState extends State<RegisterScreen> implements RegisterNavigator {
  var nameController = TextEditingController(text: 'Amira');

  var emailController = TextEditingController(text: 'amira2@route.com');

  var passwordController = TextEditingController(text: '123456');

  var confirmationPasswordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  RegisterScreenViewModel viewModel = RegisterScreenViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context ) => viewModel,
      child: Scaffold(
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
      ),
    );
  }

  void register() async{
    if(formKey.currentState?.validate() == true){
      /// register
      viewModel.register(emailController.text, passwordController.text);
    }
  }

  @override
  void hideMyLoading() {
    DialogUtils.hideLoading(context);
  }

  @override
  void showMyLoading() {
    DialogUtils.showLoading(context, 'Loading...');
  }

  @override
  void showMyMessage(String message) {
    DialogUtils.showMessage(context, message,
      posActionName: 'OK'
    );
  }
}

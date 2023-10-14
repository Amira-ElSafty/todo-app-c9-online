import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_online/components/custom_text_form_field.dart';
import 'package:flutter_app_todo_c9_online/dialog_utils.dart';
import 'package:flutter_app_todo_c9_online/firebase_utils.dart';
import 'package:flutter_app_todo_c9_online/home/home_screen.dart';
import 'package:flutter_app_todo_c9_online/login/login_navigator.dart';
import 'package:flutter_app_todo_c9_online/login/login_screen_view_model.dart';
import 'package:flutter_app_todo_c9_online/providers/auth_provider.dart';
import 'package:flutter_app_todo_c9_online/register/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginNavigator {



  LoginScreenViewModel viewModel = LoginScreenViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/main_background.png',
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Form(
              key: viewModel.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    CustomTextFormField(
                      label: 'Email Address',
                      controller: viewModel.emailController,
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
                      controller: viewModel.passwordController,
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
                          viewModel.login();
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
      ),
    );
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
   DialogUtils.showMessage(context, message,posActionName: 'Ok');
  }
}

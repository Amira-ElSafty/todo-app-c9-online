import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);
class CustomTextFormField extends StatelessWidget {
  String label ;
  TextInputType keyboardType ;
  bool isPassword ;
  TextEditingController controller ;
  Validator myValidator ;
  CustomTextFormField({required this.label,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    required this.controller,
    required this.myValidator
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(label),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 4
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 4
            ),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: isPassword,
        controller: controller,
        validator:myValidator ,
      ),
    );
  }
}

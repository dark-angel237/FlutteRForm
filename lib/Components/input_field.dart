import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData? icon;

  // Controller | to take the value from user in text field
  final TextEditingController? controller;

  //Validator | Check the value whether it's validated or not
  final FormFieldValidator? validator;

  // Text Input Formatter | Allows or denies specific data format
  final List<TextInputFormatter>? inputFormat;

  //Text Input Type | Used to show specific keyboard layout to users
  final TextInputType? inputType;
  final Widget? trailing;
  final bool isVisible;
  const InputField({super.key,
  this.label = "label name",
    this.icon,
    this.validator,
    this.controller,
    this.inputFormat,
    this.inputType,
    this.trailing,
    this.isVisible = false,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        validator: validator,
        controller: controller,
        inputFormatters: inputFormat,
        keyboardType: inputType,
        //Automatically validates without pressing the button
        autovalidateMode: AutovalidateMode.onUserInteraction,

        // ObscureText | Shows or hides text field's value to users
        obscureText: isVisible,
        decoration: InputDecoration(

          label: Text(label),
          hintText: label,
          prefixIcon: Icon(icon),
          suffixIcon: trailing,

          //enabledBorder | Default Text field decoration
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(.3),
              width: 1.5
            ),
          ),

          // FocusedBorder | OnClick decoration
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Colors.indigo,
                width: 2.5
            ),
          ),

          //errorBorder | Default error decoration border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Colors.red.shade900,
                width: 1
            ),
          ),

          //focusedErrorBorder | onClick decoration border
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Colors.red.shade900,
                width: 2
            ),
          ),


        ),
      ),
    );
  }
}

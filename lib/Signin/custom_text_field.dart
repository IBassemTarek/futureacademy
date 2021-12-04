import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String lableText;
  final String hintText;
  String? initialValue;
  bool multiline = false;
  TextInputType? textInputType = TextInputType.text;
  final Function(String?) onClick;

  // ignore: use_key_in_widget_constructors
  CustomTextField({
    required this.onClick,
    required this.hintText,
    this.initialValue,
    this.multiline = false,
    this.textInputType,
    required this.lableText,
  });

  String _errorMessage(String str) {
    switch (lableText) {
      case 'Email address':
        return 'E-mail is empty !';
      default:
        return 'Password is empty !';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // ignore: missing_return
      validator: (value) {
        if (value!.isEmpty) {
          return _errorMessage(lableText);
        } else if (lableText == 'Password' && value.length < 6) {
          return 'enter 6+ password';
        }
        // return '';
      },
      initialValue: initialValue ?? "",
      onChanged: onClick,
      maxLines: multiline ? 5 : 1,
      keyboardType: textInputType,
      style: Theme.of(context)
          .textTheme
          .bodyText1
          ?.copyWith(color: Colors.black, fontSize: 18),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          labelText: lableText,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Colors.black.withOpacity(0.5),
                fontSize: 14,
              ),
          labelStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.black.withOpacity(0.5), fontSize: 14)),
      obscureText:
          lableText == 'Password' || lableText == 'كلمة السر' ? true : false,
    );
  }
}

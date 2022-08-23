import 'package:flutter/material.dart';

import '../../../helper/utils.dart';

class OTPDigitInput extends StatelessWidget {
  final Function(String? input)? onSaved;

  const OTPDigitInput({
    Key? key,
    @required this.onSaved,
  }) : super(key: key);

  OutlineInputBorder getBorder(Color color, {double width = 1.4}){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color,
        width: width,
        style: BorderStyle.solid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
      cursorColor: Colors.black,
      maxLength: 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      showCursor: true,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onSaved: onSaved,
      onChanged: (msg){
        if(msg.length == 1) FocusScope.of(context).nextFocus();
        if(msg.length == 0) FocusScope.of(context).previousFocus();
      },
      validator: (digit) {
        digit = digit!.trim();
        if (digit.isNotEmpty && Utils.otpRegex.hasMatch(digit)) {
          return null;
        }
        return "";
      },
      decoration: InputDecoration(
        counterText: "",
        errorStyle: const TextStyle(height: 0, color: Colors.transparent),
        contentPadding: const EdgeInsets.all(3),
        enabledBorder: getBorder(Colors.black),
        focusedErrorBorder: getBorder(Colors.red,width: 3.5),
        errorBorder: getBorder(Colors.red),
        focusedBorder: getBorder(Colors.black,width: 3.5),
      ),
    );
  }
}
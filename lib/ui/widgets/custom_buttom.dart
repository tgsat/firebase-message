import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final txtColor;
  final Function() onPressed;
  final Color? borderSideColor;
  final btnColor;

  const CustomButton({ 
    Key? key,
    required this.title,
    this.txtColor = Colors.grey,
    required this.onPressed,
    this.borderSideColor,
    this.btnColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: FlatButton(
        onPressed: onPressed,
        color: btnColor,
        textColor: txtColor, 
        child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(title!,
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 14,
                    height: 1,
                    fontFamily: "SIG Headline",
                    fontWeight: FontWeight.w700,
                  )),
            ),
        shape: OutlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid,
                    width: 1.0,
                    color: borderSideColor!),
                borderRadius: const BorderRadius.all(Radius.circular(6)))),
    );
  }
}
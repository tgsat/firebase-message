import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      titlePadding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 5),
      buttonPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.only(right: 15, bottom: 10),
      title: const Text(
        "Invalid phone number",
      ),
      content: const Text(
        "The phone number is missing or has invalid characters. Make sure you "
            "enter a digit only.",
      ),
      contentTextStyle: const TextStyle(color: Colors.grey),
      actions: <Widget>[
        FlatButton(
          color: Colors.black,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
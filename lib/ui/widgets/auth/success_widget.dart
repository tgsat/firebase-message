import 'package:flutter/material.dart';
import 'package:for_you/providers/contact_providers.dart';
import 'package:for_you/providers/message_providers.dart';
import 'package:provider/provider.dart';
import '../../../helper/utils.dart';

import 'custom_raised_button.dart';

class SuccessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          //Message app SVG
          Container(
            color: Theme.of(context).primaryColor,
            height: 350,
            width: double.infinity,
          ),

          //Image
          Positioned(
            top: 40,
            right: 0,
            left: 0,
            height: 250,
            child: Image.asset(Utils.successAsset),
          ),

          Positioned(
            top: 390,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login Process Successful",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Poppins",
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
                  //View Messages Button
                  CustomRaisedButton(
                    buttonColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      context.read<MessagesProvider>().init();
                      context.read<ContactsProvider>().init();
                      // Navigator.of(context).pushNamed(HomeScreen.routeName);
                    },
                    height: 45,
                    width: 200,
                    text: "",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const[
                        Text(
                          "View messages",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 22,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:for_you/ui/screen/homescreen/widgets/body_homescreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const BodyHomeScreen(),
    );
  }
}
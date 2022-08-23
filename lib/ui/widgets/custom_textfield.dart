import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Colors iColor;
  final bool? expands;
  final bool? autocorrect;
  const CustomTextField({ Key? key,
  required this.label,
  required this.iColor,
  this.expands = false,
  this.autocorrect = false,
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12, 
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            expands: expands!,
            autocorrect: autocorrect!,
            decoration: InputDecoration(
              hintText: label,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}
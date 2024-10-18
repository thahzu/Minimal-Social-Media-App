import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding inside
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          // color of button
          color: Colors.black,

          // curved corners
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
              text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

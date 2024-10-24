import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollwing;
  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollwing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(

      // padding on outside
      padding: const EdgeInsets.symmetric(horizontal: 25.0),

      // button
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          onPressed: onPressed,

          // padding inside
          padding: const EdgeInsets.all(25),
        
          // colors
          color: isFollwing ? Theme.of(context).colorScheme.primary: Colors.blue,
        
          // text
          child: Text(
              isFollwing ? " Unfollow" : "Follow",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
          ),
        ),
      ),
    );
  }
}

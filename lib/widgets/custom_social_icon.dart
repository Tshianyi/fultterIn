import 'package:flutter/material.dart';


class CustomSocialIcon extends StatelessWidget {

  final Widget child;
  final VoidCallback? onPressed;

  const CustomSocialIcon({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: child,
      ),
    );

    if (onPressed != null) {
      return GestureDetector(
        onTap: onPressed,
        child: container,
      );
    }

    return container;
  }
}

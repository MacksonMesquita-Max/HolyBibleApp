import 'package:flutter/material.dart';

class TextActionButton extends StatelessWidget {
  const TextActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.style,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: style,
      );
    }

    return TextButton(onPressed: onPressed, style: style, child: Text(label));
  }
}

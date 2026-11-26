import 'package:flutter/material.dart';

class IconActionButton extends StatelessWidget {
  const IconActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconSize = 24,
    this.style,
    this.visualDensity,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double iconSize;
  final ButtonStyle? style;
  final VisualDensity? visualDensity;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: style,
      visualDensity: visualDensity,
      icon: Icon(icon, size: iconSize),
    );
  }
}

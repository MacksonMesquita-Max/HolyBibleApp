import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../constants/splash_animation_constants.dart';
import '../widgets/splash_content.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.onCompleted, super.key});

  final void Function(BuildContext context) onCompleted;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: SplashAnimationConstants.totalDuration,
  );

  @override
  void initState() {
    super.initState();
    _controller
      ..addStatusListener(_handleStatus)
      ..forward();
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      widget.onCompleted(context);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark.background,
      body: SplashContent(controller: _controller),
    );
  }
}

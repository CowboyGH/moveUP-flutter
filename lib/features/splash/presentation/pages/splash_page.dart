import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';

/// The first Flutter frame shown while session restore is in progress.
class SplashPage extends StatefulWidget {
  /// Creates a [SplashPage].
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _overlayColor = Color(0x42000000);
  static const backgroundImagePath = 'assets/images/splash_bg.jpg';
  static const _minSplashDuration = Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();

    final authSessionCubit = context.read<AuthSessionCubit>();
    final shouldRestoreSession = authSessionCubit.state.maybeWhen(
      initial: () => true,
      orElse: () => false,
    );
    if (shouldRestoreSession) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(_minSplashDuration, () {
          if (!mounted) return;
          unawaited(authSessionCubit.restoreSession());
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  _overlayColor,
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),
          Center(
            child: SvgPictureWidget.frame(
              'logo',
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }
}

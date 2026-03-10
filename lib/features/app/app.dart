import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/di.dart';
import '../../core/router/router.dart';
import '../../uikit/themes/app_theme_data.dart';
import '../auth/presentation/cubits/auth_session_cubit.dart';

/// The main application widget.
class MoveUpApp extends StatelessWidget {
  /// Creates a [MoveUpApp] widget.
  const MoveUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di<AuthSessionCubit>(),
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppThemeData.lightTheme,
      ),
    );
  }
}

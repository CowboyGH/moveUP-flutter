import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/di.dart';
import '../../core/localization/generated/app_localizations.g.dart';
import '../../core/router/router.dart';
import '../auth/presentation/bloc/auth_bloc.dart';

/// The main application widget.
class FlutterStarterTemplate extends StatelessWidget {
  /// Creates a [FlutterStarterTemplate] widget.
  const FlutterStarterTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<AuthBloc>(),
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}

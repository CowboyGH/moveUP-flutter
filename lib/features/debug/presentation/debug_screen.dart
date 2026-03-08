import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/di.dart';
import '../../auth/domain/repositories/auth_repository.dart';
import '../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../auth/presentation/cubits/logout_cubit.dart';

/// A screen for debugging purposes.
class DebugScreen extends StatelessWidget {
  /// Creates a [DebugScreen].
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di<AuthSessionCubit>()),
        BlocProvider(
          create: (context) => LogoutCubit(di<AuthRepository>()),
        ),
      ],
      child: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          state.whenOrNull(
            succeed: () => context.read<AuthSessionCubit>().logout(),
            failed: (failure) {
              if (failure.message.isNotEmpty) {
                final messenger = ScaffoldMessenger.of(context);
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(failure.message)));
              }
            },
          );
        },
        child: Scaffold(
          body: Center(
            child: BlocBuilder<LogoutCubit, LogoutState>(
              builder: (context, state) {
                final isInProgress = state.maybeWhen(
                  inProgress: () => true,
                  orElse: () => false,
                );
                return FilledButton(
                  onPressed: isInProgress ? null : () => context.read<LogoutCubit>().logout(),
                  child: isInProgress
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : const Text('Выйти'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/repositories/auth_repository.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/sign_up_cubit.dart';
import 'sign_up_page.dart';

/// Builder for sign-up page.
class SignUpPageBuilder extends StatelessWidget {
  /// Creates an instance of [SignUpPageBuilder].
  const SignUpPageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignUpCubit(di<AuthRepository>()),
        ),
        BlocProvider.value(value: di<AuthSessionCubit>()),
      ],
      child: const SignUpPage(),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/repositories/auth_repository.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/sign_in_cubit.dart';
import 'sign_in_page.dart';

/// Builder for sign-in page.
class SignInPageBuilder extends StatelessWidget {
  /// Creates an instance of [SignInPageBuilder].
  const SignInPageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInCubit(di<AuthRepository>()),
        ),
        BlocProvider.value(value: di<AuthSessionCubit>()),
      ],
      child: const SignInPage(),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/repositories/auth_repository.dart';
import '../cubits/forgot_password_cubit.dart';
import 'forgot_password_page.dart';

/// Builder for forgot-password page.
class ForgotPasswordPageBuilder extends StatelessWidget {
  /// Creates an instance of [ForgotPasswordPageBuilder].
  const ForgotPasswordPageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(di<AuthRepository>()),
      child: const ForgotPasswordPage(),
    );
  }
}

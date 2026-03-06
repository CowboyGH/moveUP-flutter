import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/repositories/auth_repository.dart';
import '../cubits/auth_session_cubit.dart';
import '../cubits/verify_email_cubit.dart';
import 'verify_email_page.dart';

/// Builder for verify-email page.
class VerifyEmailPageBuilder extends StatelessWidget {
  /// User email used for OTP verification.
  final String email;

  /// Creates an instance of [VerifyEmailPageBuilder].
  const VerifyEmailPageBuilder({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VerifyEmailCubit(di<AuthRepository>()),
        ),
        BlocProvider.value(value: di<AuthSessionCubit>()),
      ],
      child: VerifyEmailPage(email: email),
    );
  }
}

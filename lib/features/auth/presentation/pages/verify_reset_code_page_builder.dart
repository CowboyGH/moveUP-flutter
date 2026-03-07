import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/repositories/auth_repository.dart';
import '../cubits/otp_resend_cubit.dart';
import '../cubits/verify_reset_code_cubit.dart';
import 'verify_reset_code_page.dart';

/// Builder for verify-reset-code page.
class VerifyResetCodePageBuilder extends StatelessWidget {
  /// User email used for reset code verification.
  final String email;

  /// Creates an instance of [VerifyResetCodePageBuilder].
  const VerifyResetCodePageBuilder({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VerifyResetCodeCubit(di<AuthRepository>()),
        ),
        BlocProvider(
          create: (context) => OtpResendCubit(di<AuthRepository>()),
        ),
      ],
      child: VerifyResetCodePage(email: email),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/repositories/auth_repository.dart';
import '../cubits/reset_password_cubit.dart';
import 'reset_password_page.dart';

/// Builder for reset-password page.
class ResetPasswordPageBuilder extends StatelessWidget {
  /// User email for reset-password request.
  final String email;

  /// Verified OTP code for reset-password request.
  final String code;

  /// Creates an instance of [ResetPasswordPageBuilder].
  const ResetPasswordPageBuilder({
    required this.email,
    required this.code,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(di<AuthRepository>()),
      child: ResetPasswordPage(email: email, code: code),
    );
  }
}

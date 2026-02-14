import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../mappers/auth_failure_mapper.dart';
import '../mappers/google_auth_failure_mapper.dart';
import '../mappers/user_to_entity_mapper.dart';

/// Implementation of [AuthRepository] using Firebase Authentication.
class AuthRepositoryImpl implements AuthRepository {
  /// Logger for tracking authentication operations and errors.
  final AppLogger _logger;

  /// Firebase Authentication instance for performing auth operations.
  final fb.FirebaseAuth _auth;

  /// Google Sign-In instance for handling Google authentication.
  final GoogleSignIn _googleSignIn;

  /// Creates an instance of [AuthRepositoryImpl].
  AuthRepositoryImpl(this._logger, this._auth, this._googleSignIn);

  /// Validates credential after Firebase operation.
  Result<User, AuthFailure> _validateCredential(
    fb.UserCredential credential,
    String operation,
  ) {
    if (credential.user == null) {
      _logger.w('$operation succeeded but user is null', null, StackTrace.current);
      return Result.failure(
        UnknownAuthFailure(
          'unknown',
          originalMessage: 'User is null after $operation',
          stackTrace: StackTrace.current,
        ),
      );
    }
    _logger.i('$operation successful for user: ${credential.user!.uid}');
    return Result.success(credential.user!.toEntity());
  }

  @override
  Future<Result<User, AuthFailure>> signInWithEmail(
    String email,
    String password,
  ) async {
    _logger.d('SignIn attempt for email: $email');
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _validateCredential(credential, 'sign in');
    } on fb.FirebaseAuthException catch (e, s) {
      _logger.i('SignIn failed with Firebase error: ${e.code}', e, s);
      return Result.failure(e.toAuthFailure(s));
    } catch (e, s) {
      _logger.e('SignIn failed with unexpected error', e, s);
      return Result.failure(
        UnknownAuthFailure(
          'unknown',
          originalMessage: e.toString(),
          parentException: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<Result<User, AuthFailure>> signUpWithEmail(
    String email,
    String password,
  ) async {
    _logger.d('SignUp attempt for email: $email');
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _validateCredential(credential, 'sign up');
    } on fb.FirebaseAuthException catch (e, s) {
      _logger.i('SignUp failed with Firebase error: ${e.code}', e, s);
      return Result.failure(e.toAuthFailure(s));
    } catch (e, s) {
      _logger.e('SignUp failed with unexpected error', e, s);
      return Result.failure(
        UnknownAuthFailure(
          'unknown',
          originalMessage: e.toString(),
          parentException: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<Result<void, AuthFailure>> signOut() async {
    _logger.d('SignOut attempt');
    try {
      await _auth.signOut();
      _logger.i('SignOut successful');
      return const Result.success(null);
    } on fb.FirebaseAuthException catch (e, s) {
      _logger.i('SignOut failed with Firebase error: ${e.code}', e, s);
      return Result.failure(e.toAuthFailure(s));
    } catch (e, s) {
      _logger.e('SignOut failed with unexpected error', e, s);
      return Result.failure(
        UnknownAuthFailure(
          'unknown',
          originalMessage: e.toString(),
          parentException: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<Result<User, AuthFailure>> signInWithGoogle() async {
    _logger.d('SignInWithGoogle attempt');
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      final googleAuthCredential = fb.GoogleAuthProvider.credential(
        idToken: googleSignInAccount.authentication.idToken,
        accessToken: authorization?.accessToken,
      );

      final credential = await _auth.signInWithCredential(googleAuthCredential);

      return _validateCredential(credential, 'sign in with Google');
    } on GoogleSignInException catch (e, s) {
      _logger.i('SignInWithGoogle failed with Google error: ${e.code.name}', e, s);
      return Result.failure(e.toAuthFailure(s));
    } on fb.FirebaseAuthException catch (e, s) {
      _logger.i('SignInWithGoogle failed with Firebase error: ${e.code}', e, s);
      return Result.failure(e.toAuthFailure(s));
    } catch (e, s) {
      _logger.e('SignInWithGoogle failed with unexpected error', e, s);
      return Result.failure(
        UnknownAuthFailure(
          'unknown',
          originalMessage: e.toString(),
          parentException: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges().map(
      (fb.User? firebaseUser) {
        if (firebaseUser != null) {
          _logger.d('Auth state changed: user logged in (${firebaseUser.uid})');
          return firebaseUser.toEntity();
        } else {
          _logger.d('Auth state changed: user logged out');
          return null;
        }
      },
    );
  }
}

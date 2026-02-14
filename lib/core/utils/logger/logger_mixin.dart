import '../../di/di.dart';
import 'app_logger.dart';

/// Mixin for convenient access to AppLogger through GetIt.
///
/// Used in Bloc/Cubit for debug logging.
/// For critical components (Repository, UseCase), dependency injection
/// through the constructor is preferable for easier testing.
mixin AppLoggerMixin {
  /// Gets the [AppLogger] instance from the global DI container.
  AppLogger get logger => di<AppLogger>();
}

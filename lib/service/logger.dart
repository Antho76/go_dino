import 'package:logger/logger.dart';

class LogManager {
  static final Logger _logger = Logger();

  static void info(String message) => _logger.i(message);
  static void error(String message) => _logger.e(message);
  static void debug(String message) => _logger.d(message);
}

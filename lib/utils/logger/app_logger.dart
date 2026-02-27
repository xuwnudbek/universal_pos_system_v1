import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Daily file output
// Writes to: <Documents>/upossystem/logs/YYYY-MM-DD.log
// A new file is created automatically when the calendar day changes.
// ─────────────────────────────────────────────────────────────────────────────
class _DailyFileOutput extends LogOutput {
  IOSink? _sink;
  String? _activeDate;
  Directory? _logsDir;

  // Called once from AppLogger.init()
  @override
  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    _logsDir = Directory(p.join(appDir.path, 'upossystem', 'logs'));
    if (!await _logsDir!.exists()) {
      await _logsDir!.create(recursive: true);
    }

    super.init();
  }

  String _todayLabel() {
    final n = DateTime.now();
    return '${n.year.toString().padLeft(4, '0')}'
        '-${n.month.toString().padLeft(2, '0')}'
        '-${n.day.toString().padLeft(2, '0')}';
  }

  IOSink _getSink() {
    final today = _todayLabel();
    if (_activeDate != today || _sink == null) {
      // Flush & close previous day's sink
      _sink?.flush();
      _sink?.close();
      _activeDate = today;
      final file = File(p.join(_logsDir!.path, '$today.log'));
      _sink = file.openWrite(mode: FileMode.append);
    }
    return _sink!;
  }

  @override
  void output(OutputEvent event) {
    if (_logsDir == null) return; // not yet initialized
    try {
      final sink = _getSink();
      for (final line in event.lines) {
        sink.writeln(line);
      }
    } catch (_) {
      // silently ignore file I/O errors
    }
  }

  @override
  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Log filter — allow only Info, Warning, Error, Fatal
// ─────────────────────────────────────────────────────────────────────────────
class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => event.level.index >= Level.info.index;
}

// ─────────────────────────────────────────────────────────────────────────────
// Log printer — plain text, no ANSI colors, friendly for log files
// Format:  [LEVEL] HH:mm:ss  message
//          Error:  <error object>
//          Stack:  <stack trace>
// ─────────────────────────────────────────────────────────────────────────────
class _AppLogPrinter extends LogPrinter {
  static const _labels = {
    Level.info: 'INFO ',
    Level.warning: 'WARN ',
    Level.error: 'ERROR',
    Level.fatal: 'FATAL',
  };

  @override
  List<String> log(LogEvent event) {
    final label = _labels[event.level] ?? event.level.name.toUpperCase();
    final n = DateTime.now();
    final time =
        '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}:'
        '${n.second.toString().padLeft(2, '0')}';

    final lines = <String>['[$label] $time  ${event.message}'];
    if (event.error != null) lines.add('         Error: ${event.error}');
    if (event.stackTrace != null) {
      lines.add('         Stack: ${event.stackTrace}');
    }
    return lines;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppLogger — public API
// ─────────────────────────────────────────────────────────────────────────────
class AppLogger {
  AppLogger._();

  static final _DailyFileOutput _fileOutput = _DailyFileOutput();

  static late final Logger _logger;

  /// Must be called once before any logging, e.g. in main() before runApp().
  static Future<void> init() async {
    await _fileOutput.init();
    _logger = Logger(
      filter: _AppLogFilter(),
      printer: _AppLogPrinter(),
      output: MultiOutput([
        ConsoleOutput(), // visible in IDE / debug console
        _fileOutput, // written to daily .log file
      ]),
    );
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) => _logger.i(message, error: error, stackTrace: stackTrace);

  static void warning(String message, [Object? error, StackTrace? stackTrace]) => _logger.w(message, error: error, stackTrace: stackTrace);

  static void error(String message, [Object? error, StackTrace? stackTrace]) => _logger.e(message, error: error, stackTrace: stackTrace);

  static void fatal(String message, [Object? error, StackTrace? stackTrace]) => _logger.f(message, error: error, stackTrace: stackTrace);

  /// Flush & release the current log file handle. Call on app exit.
  static Future<void> dispose() async => _logger.close();
}

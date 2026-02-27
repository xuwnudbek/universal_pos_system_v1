import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:universal_pos_system_v1/data/local/app_database.dart';

class BackupProvider extends ChangeNotifier {
  final AppDatabase _db;

  BackupProvider(this._db) {
    _loadDatabaseInfo();
  }

  bool _isExporting = false;
  bool get isExporting => _isExporting;

  bool _isImporting = false;
  bool get isImporting => _isImporting;

  String? _lastMessage;
  String? get lastMessage => _lastMessage;

  bool? _lastSuccess;
  bool? get lastSuccess => _lastSuccess;

  int? _dbSizeBytes;
  int? get dbSizeBytes => _dbSizeBytes;

  DateTime? _dbLastModified;
  DateTime? get dbLastModified => _dbLastModified;

  String get dbSizeFormatted {
    if (_dbSizeBytes == null) return '-';
    final kb = _dbSizeBytes! / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(2)} MB';
  }

  String get dbLastModifiedFormatted {
    if (_dbLastModified == null) return '-';
    return DateFormat('dd.MM.yyyy HH:mm').format(_dbLastModified!);
  }

  Future<File> _getDatabaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'app.sqlite'));
  }

  Future<void> _loadDatabaseInfo() async {
    try {
      final file = await _getDatabaseFile();
      if (await file.exists()) {
        final stat = await file.stat();
        _dbSizeBytes = stat.size;
        _dbLastModified = stat.modified;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading database info: $e');
    }
  }

  Future<void> exportDatabase() async {
    _isExporting = true;
    _lastMessage = null;
    notifyListeners();

    try {
      final dbFile = await _getDatabaseFile();
      if (!await dbFile.exists()) {
        _lastMessage = 'Database fayl topilmadi';
        _lastSuccess = false;
        _isExporting = false;
        notifyListeners();
        return;
      }

      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final defaultFileName = 'pos_backup_$timestamp.sqlite';

      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Backup faylini saqlash',
        fileName: defaultFileName,
        type: FileType.any,
      );

      if (outputPath == null) {
        _isExporting = false;
        notifyListeners();
        return;
      }

      // Close database connections first
      await _db.customStatement('PRAGMA wal_checkpoint(FULL)');

      await dbFile.copy(outputPath);

      _lastMessage = 'Backup muvaffaqiyatli saqlandi';
      _lastSuccess = true;
    } catch (e) {
      debugPrint('Error exporting database: $e');
      _lastMessage = 'Export xatolik: $e';
      _lastSuccess = false;
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  Future<void> importDatabase() async {
    _isImporting = true;
    _lastMessage = null;
    notifyListeners();

    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Backup faylini tanlang',
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        _isImporting = false;
        notifyListeners();
        return;
      }

      final pickedFile = File(result.files.single.path!);

      // Validate that it's a valid SQLite file
      final bytes = await pickedFile.readAsBytes();
      if (bytes.length < 16 || String.fromCharCodes(bytes.sublist(0, 15)) != 'SQLite format 3') {
        _lastMessage = 'Noto\'g\'ri fayl formati. Faqat SQLite fayllarni import qilish mumkin.';
        _lastSuccess = false;
        _isImporting = false;
        notifyListeners();
        return;
      }

      final dbFile = await _getDatabaseFile();

      // Create a backup of current database before replacing
      final backupDir = await getApplicationDocumentsDirectory();
      final backupPath = p.join(backupDir.path, 'app_backup_before_import.sqlite');
      if (await dbFile.exists()) {
        await dbFile.copy(backupPath);
      }

      // Close current connection and copy new file
      await _db.customStatement('PRAGMA wal_checkpoint(FULL)');
      await pickedFile.copy(dbFile.path);

      _lastMessage = 'Import muvaffaqiyatli! Ilovani qayta ishga tushiring.';
      _lastSuccess = true;

      await _loadDatabaseInfo();
    } catch (e) {
      debugPrint('Error importing database: $e');
      _lastMessage = 'Import xatolik: $e';
      _lastSuccess = false;
    } finally {
      _isImporting = false;
      notifyListeners();
    }
  }

  void clearMessage() {
    _lastMessage = null;
    _lastSuccess = null;
    notifyListeners();
  }
}

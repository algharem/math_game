import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';

class BackupInfo {
  const BackupInfo({
    required this.path,
    required this.createdAt,
    required this.sizeBytes,
  });

  final String path;
  final DateTime createdAt;
  final int sizeBytes;

  String get fileName => p.basename(path);
}

class DataBackupService {
  DataBackupService._();

  static const databaseFileName = 'math_heroes.sqlite';
  static const _pendingRestoreKey = 'backup.pending_restore_path';
  static const _restoreErrorKey = 'backup.last_restore_error';

  static Future<Directory> _baseDirectory() async {
    return getApplicationDocumentsDirectory();
  }

  static Future<String> databasePath() async {
    final directory = await _baseDirectory();
    return p.join(directory.path, databaseFileName);
  }

  static Future<Directory> backupsDirectory() async {
    final directory = await _baseDirectory();
    final backups = Directory(p.join(directory.path, 'math_heroes_backups'));
    if (!await backups.exists()) {
      await backups.create(recursive: true);
    }
    return backups;
  }

  static Future<void> checkpoint(AppDatabase database) async {
    try {
      await database.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
    } catch (_) {
      // Best effort; database may not be in WAL mode.
    }
  }

  static Future<BackupInfo> createBackup(AppDatabase database) async {
    await checkpoint(database);
    final sourcePath = await databasePath();
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('لم يتم العثور على قاعدة البيانات المحلية.');
    }
    final backups = await backupsDirectory();
    final stamp = _stamp();
    final target =
        File(p.join(backups.path, 'math_heroes_backup_$stamp.sqlite'));
    await source.copy(target.path);
    await _copySidecarIfExists('$sourcePath-wal', '${target.path}-wal');
    await _copySidecarIfExists('$sourcePath-shm', '${target.path}-shm');
    final stat = await target.stat();
    return BackupInfo(
      path: target.path,
      createdAt: DateTime.now(),
      sizeBytes: stat.size,
    );
  }

  static Future<List<BackupInfo>> listBackups() async {
    final backups = await backupsDirectory();
    if (!await backups.exists()) return const [];
    final files = await backups
        .list()
        .where((entity) =>
            entity is File &&
            entity.path.endsWith('.sqlite') &&
            p.basename(entity.path).startsWith('math_heroes_backup_'))
        .cast<File>()
        .toList();
    files.sort(
      (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
    );
    return [
      for (final file in files)
        BackupInfo(
          path: file.path,
          createdAt: file.lastModifiedSync(),
          sizeBytes: file.lengthSync(),
        ),
    ];
  }

  static Future<void> scheduleRestoreOnNextLaunch(String backupPath) async {
    final backup = File(backupPath);
    if (!await backup.exists()) {
      throw StateError('ملف النسخة الاحتياطية غير موجود.');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_restoreErrorKey);
    await prefs.setString(_pendingRestoreKey, backupPath);
  }

  static Future<String?> takeLastRestoreError() async {
    final prefs = await SharedPreferences.getInstance();
    final error = prefs.getString(_restoreErrorKey);
    if (error != null) await prefs.remove(_restoreErrorKey);
    return error;
  }

  static Future<void> applyPendingRestoreIfAny() async {
    final prefs = await SharedPreferences.getInstance();
    final backupPath = prefs.getString(_pendingRestoreKey);
    if (backupPath == null || backupPath.trim().isEmpty) return;
    try {
      await _restoreNow(backupPath);
      await prefs.remove(_pendingRestoreKey);
      await prefs.remove(_restoreErrorKey);
    } catch (error) {
      await prefs.remove(_pendingRestoreKey);
      await prefs.setString(_restoreErrorKey, error.toString());
    }
  }

  static Future<void> _restoreNow(String backupPath) async {
    final backup = File(backupPath);
    if (!await backup.exists()) {
      throw StateError('ملف النسخة الاحتياطية غير موجود: $backupPath');
    }
    final dbPath = await databasePath();
    final dbDir = Directory(p.dirname(dbPath));
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    await _deleteIfExists('$dbPath-wal');
    await _deleteIfExists('$dbPath-shm');
    await backup.copy(dbPath);
    await _copySidecarIfExists('$backupPath-wal', '$dbPath-wal');
    await _copySidecarIfExists('$backupPath-shm', '$dbPath-shm');
  }

  static Future<void> deleteBackup(String backupPath) async {
    await _deleteIfExists(backupPath);
    await _deleteIfExists('$backupPath-wal');
    await _deleteIfExists('$backupPath-shm');
  }

  static Future<void> _copySidecarIfExists(
    String sourcePath,
    String targetPath,
  ) async {
    final source = File(sourcePath);
    if (await source.exists()) {
      await source.copy(targetPath);
    } else {
      await _deleteIfExists(targetPath);
    }
  }

  static Future<void> _deleteIfExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static String _stamp() {
    final now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${now.year}${two(now.month)}${two(now.day)}_${two(now.hour)}${two(now.minute)}${two(now.second)}';
  }
}

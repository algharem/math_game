import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart';

import '../database/app_database.dart';

class BackupInfo {
  const BackupInfo({
    required this.path,
    required this.createdAt,
    required this.sizeBytes,
    String? fileName,
    this.isSaf = false,
  }) : _fileName = fileName;

  /// Filesystem path or a content:// URI.
  final String path;
  final DateTime createdAt;
  final int sizeBytes;
  final bool isSaf;
  final String? _fileName;

  String get fileName => _fileName ?? p.basename(path);
  bool get isContentUri => path.startsWith('content://');

  /// Human-readable storage location for display/copy.
  String get locationLabel =>
      isSaf ? 'مجلد النسخ الاحتياطي (SAF)' : p.dirname(path);
}

class SafDirectory {
  const SafDirectory({required this.uri, this.name});

  final String uri;
  final String? name;
}

class DataBackupService {
  DataBackupService._();

  static const databaseFileName = 'math_heroes.sqlite';
  static const _pendingRestoreKey = 'backup.pending_restore_path';
  static const _restoreErrorKey = 'backup.last_restore_error';
  static const _safTreeUriKey = 'backup.saf_tree_uri';
  static const _safTreeNameKey = 'backup.saf_tree_name';
  static const MethodChannel _saf = MethodChannel('math_heroes/saf_backup');

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

  // ---- SAF backup folder (persistent, survives uninstall) ----

  static Future<SafDirectory?> getSafDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    final uri = prefs.getString(_safTreeUriKey);
    if (uri == null || uri.isEmpty) return null;
    return SafDirectory(uri: uri, name: prefs.getString(_safTreeNameKey));
  }

  static Future<SafDirectory?> pickSafDirectory() async {
    try {
      final result = await _saf.invokeMethod<Map>('pickDirectory');
      if (result == null) return null;
      final uri = '${result['uri'] ?? ''}';
      if (uri.isEmpty) return null;
      final name = result['name']?.toString();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_safTreeUriKey, uri);
      if (name != null) await prefs.setString(_safTreeNameKey, name);
      return SafDirectory(uri: uri, name: name);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  static Future<void> clearSafDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    final uri = prefs.getString(_safTreeUriKey);
    if (uri != null) {
      try {
        await _saf.invokeMethod('releasePermission', {'uri': uri});
      } catch (_) {}
    }
    await prefs.remove(_safTreeUriKey);
    await prefs.remove(_safTreeNameKey);
  }

  static Future<List<BackupInfo>> listSafBackups() async {
    final dir = await getSafDirectory();
    if (dir == null) return const [];
    try {
      final result =
          await _saf.invokeMethod<List>('listBackups', {'treeUri': dir.uri});
      final items = <BackupInfo>[];
      for (final raw in result ?? const []) {
        if (raw is! Map) continue;
        final uri = '${raw['uri'] ?? ''}';
        final name = '${raw['name'] ?? ''}';
        if (uri.isEmpty || name.isEmpty) continue;
        final size = (raw['size'] is num) ? (raw['size'] as num).toInt() : 0;
        final modified = (raw['lastModified'] is num)
            ? (raw['lastModified'] as num).toInt()
            : 0;
        items.add(BackupInfo(
          path: uri,
          fileName: name,
          createdAt: modified > 0
              ? DateTime.fromMillisecondsSinceEpoch(modified)
              : DateTime.fromMillisecondsSinceEpoch(0),
          sizeBytes: size,
          isSaf: true,
        ));
      }
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    } catch (_) {
      return const [];
    }
  }

  // ---- Database checkpoint ----

  static Future<void> checkpoint(AppDatabase database) async {
    try {
      await database.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
    } catch (_) {
      // Best effort; database may not be in WAL mode.
    }
  }

  // ---- Private (app-internal) backups ----

  static Future<BackupInfo> createBackup(AppDatabase database) async {
    await checkpoint(database);
    final sourcePath = await databasePath();
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('لم يتم العثور على قاعدة البيانات المحلية.');
    }

    // Prefer persistent SAF folder when configured.
    final safDir = await getSafDirectory();
    if (safDir != null) {
      try {
        final fileName = 'math_heroes_backup_${_stamp()}.sqlite';
        final result = await _saf.invokeMethod<Map>('createBackup', {
          'treeUri': safDir.uri,
          'fileName': fileName,
          'sourcePath': sourcePath,
        });
        if (result != null) {
          final uri = '${result['uri'] ?? ''}';
          final name = '${result['name'] ?? fileName}';
          final size = (result['size'] is num)
              ? (result['size'] as num).toInt()
              : await source.length();
          final modified = (result['lastModified'] is num)
              ? (result['lastModified'] as num).toInt()
              : DateTime.now().millisecondsSinceEpoch;
          if (uri.isNotEmpty) {
            return BackupInfo(
              path: uri,
              fileName: name,
              createdAt: DateTime.fromMillisecondsSinceEpoch(modified),
              sizeBytes: size,
              isSaf: true,
            );
          }
        }
      } catch (_) {
        // Fall through to private storage.
      }
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

  static Future<List<BackupInfo>> listPrivateBackups() async {
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
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return [
      for (final file in files)
        BackupInfo(
          path: file.path,
          createdAt: file.lastModifiedSync(),
          sizeBytes: file.lengthSync(),
        ),
    ];
  }

  /// Lists backups from the configured SAF folder if set, otherwise private.
  /// Always also returns legacy private backups separately via [listPrivateBackups].
  static Future<List<BackupInfo>> listBackups() async {
    final safDir = await getSafDirectory();
    if (safDir != null) {
      return listSafBackups();
    }
    return listPrivateBackups();
  }

  /// Copies an external backup file into the app's private backup folder.
  static Future<BackupInfo> importBackupFile(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('ملف النسخة الاحتياطية غير موجود.');
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

  /// Resolve a backup (path or content:// URI) to a readable local file path.
  /// For content URIs, copies to cache and returns the cache path.
  static Future<String> resolveToLocalPath(BackupInfo backup) async {
    if (!backup.isContentUri) return backup.path;
    try {
      final cacheName =
          'restore_${DateTime.now().microsecondsSinceEpoch}_${backup.fileName}';
      final local = await _saf.invokeMethod<String>('readToCache', {
        'uri': backup.path,
        'cacheName': cacheName,
      });
      if (local != null && local.isNotEmpty) return local;
    } catch (_) {}
    throw StateError('تعذر قراءة النسخة الاحتياطية من المجلد المختار.');
  }

  static Future<Uint8List> readBackupBytes(BackupInfo backup) async {
    if (!backup.isContentUri) {
      return File(backup.path).readAsBytes();
    }
    final local = await resolveToLocalPath(backup);
    try {
      return await File(local).readAsBytes();
    } finally {
      await _deleteIfExists(local);
    }
  }

  /// Opens the backup and checks that it is a healthy SQLite file that actually
  /// contains the app's tables. Accepts a local filesystem path.
  static Future<void> verifyBackup(String backupPath) async {
    final backup = File(backupPath);
    if (!await backup.exists()) {
      throw StateError('ملف النسخة الاحتياطية غير موجود.');
    }
    Database? db;
    try {
      db = sqlite3.open(backupPath, mode: OpenMode.readOnly);
      final integrity = db.select('PRAGMA integrity_check');
      final value =
          integrity.isEmpty ? '' : '${integrity.first.values.first}'.trim();
      if (value.toLowerCase() != 'ok') {
        throw StateError('النسخة الاحتياطية تالفة ($value).');
      }
      final tables = db
          .select("SELECT name FROM sqlite_master WHERE type = 'table'")
          .map((row) => '${row['name']}')
          .toSet();
      for (final required in const ['profiles', 'users', 'exam_records']) {
        if (!tables.contains(required)) {
          throw StateError(
            'الملف المختار ليس نسخة احتياطية صالحة من التطبيق (جدول $required مفقود).',
          );
        }
      }
    } on StateError {
      rethrow;
    } catch (error) {
      throw StateError('تعذر قراءة النسخة الاحتياطية: $error');
    } finally {
      db?.dispose();
    }
  }

  static Future<void> verifyBackupInfo(BackupInfo backup) async {
    final local = await resolveToLocalPath(backup);
    try {
      await verifyBackup(local);
    } finally {
      if (backup.isContentUri) {
        await _deleteIfExists(local);
      }
    }
  }

  static Future<void> scheduleRestoreOnNextLaunch(String backupPath) async {
    // backupPath may be a content URI or a file path; resolve for validation.
    if (backupPath.startsWith('content://')) {
      final cacheName =
          'validate_${DateTime.now().microsecondsSinceEpoch}.sqlite';
      final local = await _saf.invokeMethod<String>(
          'readToCache', {'uri': backupPath, 'cacheName': cacheName});
      if (local == null || local.isEmpty) {
        throw StateError('تعذر قراءة النسخة الاحتياطية من المجلد المختار.');
      }
      try {
        await verifyBackup(local);
      } finally {
        await _deleteIfExists(local);
      }
    } else {
      await verifyBackup(backupPath);
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
    String localPath = backupPath;
    String? tempCachePath;
    if (backupPath.startsWith('content://')) {
      final cacheName =
          'restore_${DateTime.now().microsecondsSinceEpoch}.sqlite';
      final local = await _saf.invokeMethod<String>(
          'readToCache', {'uri': backupPath, 'cacheName': cacheName});
      if (local == null || local.isEmpty) {
        throw StateError('تعذر قراءة النسخة الاحتياطية من المجلد المختار.');
      }
      localPath = local;
      tempCachePath = local;
    }
    try {
      final backup = File(localPath);
      if (!await backup.exists()) {
        throw StateError('ملف النسخة الاحتياطية غير موجود: $backupPath');
      }
      await verifyBackup(localPath);
      final dbPath = await databasePath();
      final dbDir = Directory(p.dirname(dbPath));
      if (!await dbDir.exists()) {
        await dbDir.create(recursive: true);
      }
      // Keep the data we are about to replace so a bad restore stays reversible.
      final current = File(dbPath);
      if (await current.exists()) {
        final backups = await backupsDirectory();
        final safety = File(
          p.join(backups.path,
              'math_heroes_backup_${_stamp()}_before_restore.sqlite'),
        );
        await current.copy(safety.path);
      }
      await _deleteIfExists('$dbPath-wal');
      await _deleteIfExists('$dbPath-shm');
      await backup.copy(dbPath);
      await _copySidecarIfExists('$localPath-wal', '$dbPath-wal');
      await _copySidecarIfExists('$localPath-shm', '$dbPath-shm');
    } finally {
      if (tempCachePath != null) {
        await _deleteIfExists(tempCachePath);
      }
    }
  }

  static Future<void> deleteBackupInfo(BackupInfo backup) async {
    if (backup.isSaf || backup.isContentUri) {
      try {
        await _saf.invokeMethod('deleteDocument', {'uri': backup.path});
      } catch (_) {}
      return;
    }
    await deleteBackup(backup.path);
  }

  static Future<void> deleteBackup(String backupPath) async {
    if (backupPath.startsWith('content://')) {
      try {
        await _saf.invokeMethod('deleteDocument', {'uri': backupPath});
      } catch (_) {}
      return;
    }
    await _deleteIfExists(backupPath);
    await _deleteIfExists('$backupPath-wal');
    await _deleteIfExists('$backupPath-shm');
  }

  /// Export/migrate all private backups into the configured SAF folder.
  static Future<int> migratePrivateBackupsToSaf() async {
    final safDir = await getSafDirectory();
    if (safDir == null) throw StateError('لم يتم اختيار مجلد نسخ بعد.');
    final private = await listPrivateBackups();
    var count = 0;
    for (final b in private) {
      try {
        await _saf.invokeMethod<Map>('createBackup', {
          'treeUri': safDir.uri,
          'fileName': b.fileName,
          'sourcePath': b.path,
        });
        count++;
      } catch (_) {}
    }
    return count;
  }

  static Future<void> _copySidecarIfExists(
      String sourcePath, String targetPath) async {
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

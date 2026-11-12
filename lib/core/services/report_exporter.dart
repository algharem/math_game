import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../shared/models/stats_models.dart';
import '../database/app_database.dart';

class ReportExporter {
  ReportExporter._();

  static Future<File> exportJson({
    required Profile profile,
    required ProfileStats stats,
    required List<ExamRecord> exams,
  }) async {
    final data = <String, Object?>{
      'exportedAt': DateTime.now().toIso8601String(),
      'profile': {
        'id': profile.id,
        'name': profile.name,
        'stars': profile.stars,
        'gems': profile.gems,
        'points': profile.points,
      },
      'stats': {
        'examsCount': stats.examsCount,
        'totalQuestions': stats.totalQuestions,
        'correctAnswers': stats.correctAnswers,
        'wrongAnswers': stats.wrongAnswers,
        'unanswered': stats.unanswered,
        'accuracy': stats.accuracy,
        'bestAccuracy': stats.bestAccuracy,
        'learningSeconds': stats.learningSeconds,
        'todayExamsCount': stats.todayExamsCount,
        'perfectExams': stats.perfectExams,
        'subjects': {
          for (final entry in stats.subjects.entries)
            entry.key.name: {
              'answered': entry.value.answered,
              'correct': entry.value.correct,
              'wrong': entry.value.wrong,
              'accuracy': entry.value.accuracy,
            },
        },
      },
      'exams': [
        for (final exam in exams)
          {
            'sessionId': exam.sessionId,
            'title': exam.title,
            'section': exam.section,
            'difficulty': exam.difficulty,
            'answerMode': exam.answerMode,
            'source': exam.source,
            'total': exam.total,
            'correct': exam.correct,
            'wrong': exam.wrong,
            'unanswered': exam.unanswered,
            'stars': exam.starsEarned,
            'gems': exam.gemsEarned,
            'points': exam.pointsEarned,
            'durationSeconds': exam.durationSeconds,
            'startedAt': exam.startedAt?.toIso8601String(),
            'createdAt': exam.createdAt.toIso8601String(),
            'status': exam.status,
          },
      ],
    };
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(
        directory.path,
        'math_heroes_${_safeName(profile.name)}_${_stamp()}.json',
      ),
    );
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
      flush: true,
    );
    return file;
  }

  static Future<File> exportCsv({
    required Profile profile,
    required List<ExamRecord> exams,
  }) async {
    final buffer = StringBuffer()
      ..writeln(
        'session_id,title,section,difficulty,answer_mode,source,total,correct,wrong,unanswered,stars,gems,points,duration_seconds,started_at,created_at,status',
      );
    for (final exam in exams) {
      buffer.writeln(
        [
          _csv(exam.sessionId),
          _csv(exam.title),
          _csv(exam.section),
          _csv(exam.difficulty),
          _csv(exam.answerMode),
          _csv(exam.source),
          exam.total,
          exam.correct,
          exam.wrong,
          exam.unanswered,
          exam.starsEarned,
          exam.gemsEarned,
          exam.pointsEarned,
          exam.durationSeconds,
          _csv(exam.startedAt?.toIso8601String() ?? ''),
          _csv(exam.createdAt.toIso8601String()),
          _csv(exam.status),
        ].join(','),
      );
    }
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      p.join(
        directory.path,
        'math_heroes_${_safeName(profile.name)}_${_stamp()}.csv',
      ),
    );
    await file.writeAsString(buffer.toString(), flush: true);
    return file;
  }

  static String _safeName(String name) {
    final cleaned = name.replaceAll(
      RegExp(r'[^A-Za-z0-9_\u0600-\u06FF-]'),
      '_',
    );
    return cleaned.isEmpty ? 'player' : cleaned;
  }

  static String _stamp() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
  }

  static String _csv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/network/parent_lan_client.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/auth_models.dart';
import '../../shared/models/remote_parent_models.dart';
import '../../shared/widgets/app_widgets.dart';

class RemoteParentDashboardScreen extends ConsumerStatefulWidget {
  const RemoteParentDashboardScreen({super.key, required this.session});

  final RemoteParentSession session;

  @override
  ConsumerState<RemoteParentDashboardScreen> createState() =>
      _RemoteParentDashboardScreenState();
}

class _RemoteParentDashboardScreenState
    extends ConsumerState<RemoteParentDashboardScreen> {
  Timer? _timer;
  bool _loading = true;
  bool _refreshing = false;
  bool _connected = true;
  String? _error;
  DateTime? _lastSync;
  List<RemoteStudentSummary> _students = const [];
  String? _selectedProfileId;
  RemoteStudentDetail? _detail;

  ParentLanClient get _client => widget.session.client;

  @override
  void initState() {
    super.initState();
    _load();
    _timer =
        Timer.periodic(const Duration(seconds: 20), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (_refreshing) return;
    _refreshing = true;
    if (!silent && mounted) {
      setState(() {
        _loading = _detail == null;
        _error = null;
      });
    }
    try {
      final students = await _client.fetchStudents();
      var selectedId = _selectedProfileId;
      if (selectedId == null ||
          !students.any((student) => student.profileId == selectedId)) {
        selectedId = students.isEmpty ? null : students.first.profileId;
      }
      RemoteStudentDetail? detail;
      if (selectedId != null) {
        detail = await _client.fetchStudentDetail(selectedId);
      }
      if (!mounted) return;
      setState(() {
        _students = students;
        _selectedProfileId = selectedId;
        _detail = detail;
        _connected = true;
        _error = null;
        _lastSync = DateTime.now();
        _loading = false;
      });
      await ref.read(settingsServiceProvider).saveRemoteParentConnection(
            url: widget.session.connection.baseUrl,
            loginName: _client.username ?? widget.session.connection.loginName,
            deviceName: widget.session.connection.deviceName,
            lastSync: _lastSync,
          );
    } catch (error) {
      if (!mounted) return;
      final message = error is LanApiException
          ? error.message
          : 'تعذر تحديث البيانات من هاتف الأبناء.';
      final unauthorized = error is LanApiException && error.unauthorized;
      if (unauthorized && !_client.hasCredentials) {
        _timer?.cancel();
        _client.close();
        context.go('/parent-remote/login', extra: widget.session.connection);
        return;
      }
      setState(() {
        _connected = false;
        _error = message;
        _loading = false;
      });
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _logout() async {
    _timer?.cancel();
    await _client.logout();
    _client.close();
    if (mounted) context.go('/parent-remote/connect');
  }

  @override
  Widget build(BuildContext context) {
    return PlayfulScaffold(
      accent: AppColors.sky,
      appBar: AppBar(
        title: const Text('متابعة الأبناء'),
        leading: IconButton(
          tooltip: 'تحديث',
          onPressed: () => _load(),
          icon: const Icon(Icons.refresh_rounded),
        ),
        actions: [
          IconButton(
            tooltip: 'تسجيل الخروج',
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: _loading
          ? const LoadingView(message: 'نجلب بيانات الأبناء...')
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                children: [
                  _ConnectionStatusCard(
                    connected: _connected,
                    lastSync: _lastSync,
                    baseUrl: widget.session.connection.baseUrl,
                    error: _connected ? null : _error,
                  ),
                  const SizedBox(height: 14),
                  if (_students.isEmpty)
                    const EmptyState(
                      title: 'لا يوجد طلاب',
                      message: 'أضف طلاباً من هاتف الأبناء لعرض تقدمهم هنا.',
                      icon: Icons.school_outlined,
                    )
                  else ...[
                    _StudentsPicker(
                      students: _students,
                      selectedId: _selectedProfileId,
                      onSelected: (id) async {
                        setState(() => _selectedProfileId = id);
                        await _load();
                      },
                    ),
                    if (_detail != null) ...[
                      const SizedBox(height: 14),
                      _StudentHeader(detail: _detail!),
                      const SizedBox(height: 14),
                      _StatsGrid(stats: _detail!.stats, daily: _detail!.daily),
                      const SizedBox(height: 14),
                      _LevelsCard(levels: _detail!.levels),
                      const SizedBox(height: 14),
                      _SubjectsCard(subjects: _detail!.stats.subjects),
                      const SizedBox(height: 14),
                      _MasteryCard(mastery: _detail!.mastery),
                      const SizedBox(height: 14),
                      _ExamsCard(
                        exams: _detail!.exams,
                        onShowAll: () => _showAllExams(_detail!.exams),
                      ),
                    ] else if (_error != null)
                      ErrorRetryView(message: _error!, onRetry: _load),
                  ],
                ],
              ),
            ),
    );
  }

  Future<void> _showAllExams(List<RemoteExamRecord> exams) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          builder: (context, controller) => ListView.builder(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: exams.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'جميع المحاولات (${ArabicNumbers.formatInt(exams.length)})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ExamTile(exam: exams[index - 1]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ConnectionStatusCard extends StatelessWidget {
  const _ConnectionStatusCard({
    required this.connected,
    required this.lastSync,
    required this.baseUrl,
    this.error,
  });

  final bool connected;
  final DateTime? lastSync;
  final String baseUrl;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final color = connected ? AppColors.leafSoft : AppColors.sunSoft;
    final border = connected ? AppColors.leaf : AppColors.sunDeep;
    final title = connected ? 'متصل بهاتف الأبناء' : 'انقطع الاتصال';
    final subtitle = connected
        ? 'آخر تحديث: ${_formatDateTime(lastSync)}'
        : (lastSync == null
            ? 'سنحاول إعادة الاتصال تلقائياً.'
            : 'البيانات المعروضة قديمة. آخر مزامنة: ${_formatDateTime(lastSync)}');
    return AppCard(
      color: color,
      borderColor: border.withValues(alpha: 0.3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            connected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
            color: connected ? AppColors.leafDeep : AppColors.sunDeep,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                Text(
                  baseUrl,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                if (error != null && !connected)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      error!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.coralDeep,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentsPicker extends StatelessWidget {
  const _StudentsPicker({
    required this.students,
    required this.selectedId,
    required this.onSelected,
  });

  final List<RemoteStudentSummary> students;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final student in students)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(student.name),
                selected: student.profileId == selectedId,
                onSelected: (_) => onSelected(student.profileId),
              ),
            ),
        ],
      ),
    );
  }
}

class _StudentHeader extends StatelessWidget {
  const _StudentHeader({required this.detail});

  final RemoteStudentDetail detail;

  @override
  Widget build(BuildContext context) {
    final student = detail.student;
    final avatar = AppAssets
        .profileAvatars[student.avatarIndex % AppAssets.profileAvatars.length];
    return AppCard(
      child: Row(
        children: [
          Image.asset(avatar, width: 62, height: 62, fit: BoxFit.contain),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${schoolGradeLabel(student.schoolGrade)} • المستوى ${ArabicNumbers.formatInt(student.currentLevel)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                Text(
                  'أكمل ${ArabicNumbers.formatInt(student.completedLevels)} من ${ArabicNumbers.formatInt(detail.levels.totalLevels)} مستوى',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.leafDeep,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats, required this.daily});

  final RemoteProfileStats stats;
  final RemoteDailyStatus daily;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.85,
      children: [
        _StatCard(
          label: 'اختبارات اليوم',
          value: ArabicNumbers.formatInt(stats.todayExamsCount),
          icon: Icons.today_rounded,
          color: AppColors.sky,
        ),
        _StatCard(
          label: 'متوسط الأداء',
          value: ArabicNumbers.formatPercent(stats.accuracy),
          icon: Icons.insights_rounded,
          color: AppColors.leaf,
        ),
        _StatCard(
          label: 'أفضل نتيجة',
          value: ArabicNumbers.formatPercent(stats.bestAccuracy),
          icon: Icons.emoji_events_rounded,
          color: AppColors.sun,
        ),
        _StatCard(
          label: 'سلسلة التحدي',
          value: '${ArabicNumbers.formatInt(daily.streak)} أيام',
          icon: Icons.local_fire_department_rounded,
          color: AppColors.coral,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
          ),
        ],
      ),
    );
  }
}

class _LevelsCard extends StatelessWidget {
  const _LevelsCard({required this.levels});

  final RemoteLevelOverview levels;

  @override
  Widget build(BuildContext context) {
    final current = levels.current;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تطور المستوى', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: levels.completionRatio.clamp(0, 1),
            minHeight: 10,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          Text(
            '${ArabicNumbers.formatInt(levels.completedCount)} / ${ArabicNumbers.formatInt(levels.totalLevels)} مستوى مكتمل',
          ),
          if (current != null) ...[
            const SizedBox(height: 10),
            Text(
              'المستوى الحالي: ${ArabicNumbers.formatInt(current.levelNumber)} — ${current.title}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              current.objectives,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
          ],
          if (levels.recentCompleted.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final level in levels.recentCompleted.take(6))
                  Chip(
                    label: Text(
                      'مستوى ${ArabicNumbers.formatInt(level.levelNumber)}',
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SubjectsCard extends StatelessWidget {
  const _SubjectsCard({required this.subjects});

  final List<RemoteSubjectPerformance> subjects;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('المهارات', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          if (subjects.isEmpty)
            Text(
              'ستظهر المهارات بعد إجراء الاختبارات.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            )
          else
            for (final subject in subjects)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(subject.label)),
                        Text(ArabicNumbers.formatPercent(subject.accuracy)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (subject.accuracy / 100).clamp(0, 1),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _MasteryCard extends StatelessWidget {
  const _MasteryCard({required this.mastery});

  final RemoteMasteryOverview mastery;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ما يتقنه وما يحتاج تحسينه',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text('يتقنه', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          if (mastery.strengths.isEmpty)
            Text(
              'لا توجد نقاط إتقان كافية بعد.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in mastery.strengths)
                  Chip(
                    label: Text(item),
                    backgroundColor: AppColors.leafSoft,
                  ),
              ],
            ),
          const SizedBox(height: 12),
          Text('يحتاج تحسيناً', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          if (mastery.improvements.isEmpty)
            Text(
              'لا توجد نقاط ضعف ظاهرة حالياً.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in mastery.improvements)
                  Chip(
                    label: Text(item),
                    backgroundColor: AppColors.coralSoft,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ExamsCard extends StatelessWidget {
  const _ExamsCard({required this.exams, required this.onShowAll});

  final List<RemoteExamRecord> exams;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'الاختبارات السابقة',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (exams.isNotEmpty)
                TextButton(
                  onPressed: onShowAll,
                  child: Text(
                    'عرض الكل (${ArabicNumbers.formatInt(exams.length)})',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (exams.isEmpty)
            Text(
              'لا توجد اختبارات بعد.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            )
          else
            for (final exam in exams.take(8))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ExamTile(exam: exam),
              ),
        ],
      ),
    );
  }
}

class _ExamTile extends StatelessWidget {
  const _ExamTile({required this.exam});

  final RemoteExamRecord exam;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exam.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                ArabicNumbers.formatPercent(exam.accuracy),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: exam.accuracy >= 80
                          ? AppColors.leafDeep
                          : AppColors.coralDeep,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${exam.sectionLabel} • ${exam.difficultyLabel} • ${ArabicNumbers.formatInt(exam.correct)} / ${ArabicNumbers.formatInt(exam.total)} • ${ArabicNumbers.formatInt(exam.durationSeconds)} ث',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
          ),
          Text(
            _formatDateTime(exam.createdAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
          ),
        ],
      ),
    );
  }
}

String _formatDateTime(DateTime? value) {
  if (value == null) return '—';
  final local = value.toLocal();
  final date =
      '${local.year}/${local.month.toString().padLeft(2, '0')}/${local.day.toString().padLeft(2, '0')}';
  final time =
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  return ArabicNumbers.toArabicDigits('$date $time');
}

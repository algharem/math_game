import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/database/app_database.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/data_backup_service.dart';
import '../../core/services/report_exporter.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/auth_models.dart';
import '../../shared/models/level_overview.dart';
import '../../shared/models/stats_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../login/login_screen.dart';

class ParentScreen extends ConsumerStatefulWidget {
  const ParentScreen({super.key});

  @override
  ConsumerState<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends ConsumerState<ParentScreen> {
  bool _syncScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncSelection());
  }

  void _scheduleSync() {
    if (_syncScheduled) return;
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (mounted) _syncSelection();
    });
  }

  void _syncSelection() {
    final accounts = ref.read(accountsProvider).valueOrNull;
    if (accounts == null) return;
    final students = accounts.where((account) => account.isStudent).toList();
    final selectedId = ref.read(parentSelectedProfileIdProvider);
    final selected =
        students.where((account) => account.profileId == selectedId);
    if (selected.isNotEmpty) {
      final account = selected.first;
      final current = ref.read(activeProfileProvider);
      if (current?.id != account.profileId) {
        ref.read(activeProfileProvider.notifier).setProfile(account.profile);
      }
      return;
    }
    if (students.isEmpty) {
      ref.read(parentSelectedProfileIdProvider.notifier).state = null;
      ref.read(activeProfileProvider.notifier).clear();
      return;
    }
    _selectStudent(students.first);
  }

  void _selectStudent(AccountSummary account) {
    if (account.profile == null) return;
    ref.read(parentSelectedProfileIdProvider.notifier).state =
        account.profileId;
    ref.read(activeProfileProvider.notifier).setProfile(account.profile);
  }

  Future<void> _logout() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'تسجيل الخروج؟',
      message: 'سيتم قفل لوحة ولي الأمر والعودة إلى شاشة الدخول.',
      confirmLabel: 'تسجيل الخروج',
    );
    if (!confirmed || !mounted) return;
    await ref.read(authProvider.notifier).logout();
    if (mounted) context.go('/login');
  }


  Future<void> _openBackupRestore() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => _BackupRestoreSheet(ref: ref),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    if (auth == null || !auth.isParent) return const LoginScreen();
    ref.listen(accountsProvider, (previous, next) {
      if (next.hasValue) _scheduleSync();
    });
    final accountsAsync = ref.watch(accountsProvider);
    final selected = ref.watch(selectedParentStudentProvider);
    if (accountsAsync.valueOrNull != null && selected == null) {
      _scheduleSync();
    }

    return DefaultTabController(
      length: 4,
      child: PlayfulScaffold(
        accent: AppColors.leaf,
        appBar: AppBar(
          title: const Text('لوحة ولي الأمر'),
          actions: [
            IconButton(
              tooltip: 'تسجيل الخروج',
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded),
            ),
            const SizedBox(width: 6),
          ],
          bottom: const TabBar(
            labelColor: AppColors.leafDeep,
            unselectedLabelColor: AppColors.mutedForeground,
            indicatorColor: AppColors.leaf,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: [
              Tab(text: 'الطلاب'),
              Tab(text: 'التقدم'),
              Tab(text: 'الإدارة'),
              Tab(text: 'التقارير'),
            ],
          ),
        ),
        body: accountsAsync.when(
          loading: () => const LoadingView(message: 'نجهّز حسابات الطلاب...'),
          error: (error, stackTrace) => ErrorRetryView(
            message: 'تعذر تحميل الحسابات.',
            onRetry: () => ref.invalidate(accountsProvider),
          ),
          data: (accounts) {
            final students =
                accounts.where((account) => account.isStudent).toList();
            return TabBarView(
              children: [
                _StudentsTab(
                  students: students,
                  selected: selected,
                  onSelect: _selectStudent,
                  onAdd: () => _openStudentForm(context, ref),
                  onEdit: (account) =>
                      _openStudentForm(context, ref, account: account),
                  onDelete: (account) => _deleteStudent(ref, account),
                ),
                _ProgressTab(account: selected),
                _ManageTab(
                  account: selected,
                  onAdd: () => _openStudentForm(context, ref),
                  onEdit: (account) =>
                      _openStudentForm(context, ref, account: account),
                  onChangePassword: (account) =>
                      _changeStudentPassword(context, ref, account),
                  onChangeParentPassword: () =>
                      _changeParentPassword(context, ref),
                  onBackupRestore: () => _openBackupRestore(),
                  onDelete: (account) => _deleteStudent(ref, account),
                  onResetProgress: (account) =>
                      _resetProgress(context, ref, account),
                  onLogout: _logout,
                ),
                _ReportsTab(account: selected, onLogout: _logout),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openStudentForm(
    BuildContext context,
    WidgetRef ref, {
    AccountSummary? account,
  }) async {
    final created = await showModalBottomSheet<AccountSummary>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _StudentFormSheet(account: account),
    );
    if (created == null || !context.mounted) return;
    _selectStudent(created);
    showAppSnack(
      context,
      account == null
          ? 'تمت إضافة ${created.displayName}.'
          : 'تم تحديث بيانات ${created.displayName}.',
    );
  }

  Future<void> _deleteStudent(WidgetRef ref, AccountSummary account) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'حذف حساب ${account.displayName}؟',
      message:
          'سيُخفى الحساب من شاشة الدخول، لكن ستُحفظ نتائج الطالب ومحاولاته للرجوع إليها. يمكن لولي الأمر إعادة تفعيله لاحقاً من قاعدة البيانات.',
      confirmLabel: 'حذف الحساب',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(accountsProvider.notifier).removeStudent(account);
      if (ref.read(parentSelectedProfileIdProvider) == account.profileId) {
        ref.read(parentSelectedProfileIdProvider.notifier).state = null;
        ref.read(activeProfileProvider.notifier).clear();
      }
      _scheduleSync();
      if (mounted) {
        showAppSnack(context, 'تم حذف حساب ${account.displayName}.');
      }
    } catch (error) {
      if (mounted) {
        showAppSnack(context, 'تعذر حذف الحساب.', isError: true);
      }
    }
  }

  Future<void> _changeStudentPassword(
    BuildContext context,
    WidgetRef ref,
    AccountSummary account,
  ) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (context) => _ChangePasswordDialog(account: account),
    );
    if (changed == true && context.mounted) {
      showAppSnack(context, 'تم تغيير كلمة مرور ${account.displayName}.');
    }
  }

  Future<void> _changeParentPassword(
      BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authProvider);
    if (auth == null) return;
    final changed = await showDialog<bool>(
      context: context,
      builder: (context) => _ChangePasswordDialog(
        account: auth.account,
        requireCurrent: true,
      ),
    );
    if (changed == true && context.mounted) {
      showAppSnack(context, 'تم تغيير كلمة مرور ولي الأمر.');
    }
  }

  Future<void> _resetProgress(
    BuildContext context,
    WidgetRef ref,
    AccountSummary account,
  ) async {
    final profile = account.profile;
    if (profile == null) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'إعادة تعيين تقدم ${account.displayName}؟',
      message:
          'سيتم حذف النجوم والجواهر وسجل الاختبارات والمستويات المكتملة لهذا الطالب. لا يمكن التراجع.',
      confirmLabel: 'إعادة التعيين',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(databaseProvider).resetProfileProgress(profile.id);
      _invalidateStudentData(ref, profile.id);
      await ref.read(activeProfileProvider.notifier).refreshActiveProfile();
      await ref.read(accountsProvider.notifier).refreshAccounts();
      if (context.mounted) {
        showAppSnack(context, 'تمت إعادة تعيين التقدم.');
      }
    } catch (error) {
      if (context.mounted) {
        showAppSnack(context, 'تعذرت إعادة التعيين.', isError: true);
      }
    }
  }
}

void _invalidateStudentData(WidgetRef ref, String profileId) {
  ref.invalidate(studentLevelOverviewProvider(profileId));
  ref.invalidate(profileStatsProvider);
  ref.invalidate(dailyStatusProvider);
  ref.invalidate(achievementsProvider);
  ref.invalidate(tableMasteryProvider);
  ref.invalidate(examHistoryProvider);
  ref.invalidate(factMasteryProvider);
  ref.invalidate(unlockedCosmeticsProvider);
  ref.invalidate(profilesProvider);
}

class _StudentsTab extends StatelessWidget {
  const _StudentsTab({
    required this.students,
    required this.selected,
    required this.onSelect,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<AccountSummary> students;
  final AccountSummary? selected;
  final ValueChanged<AccountSummary> onSelect;
  final VoidCallback onAdd;
  final ValueChanged<AccountSummary> onEdit;
  final ValueChanged<AccountSummary> onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'الطلاب',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('إضافة طالب'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (students.isEmpty)
          AppCard(
            child: Column(
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 46,
                  color: AppColors.skyDeep,
                ),
                const SizedBox(height: 10),
                Text(
                  'لا يوجد طلاب بعد',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'أضف طالباً وحدد له كلمة مرور ليبدأ رحلة التعلم.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                const SizedBox(height: 14),
                PressButton(
                  onPressed: onAdd,
                  child: const Text('إضافة أول طالب'),
                ),
              ],
            ),
          )
        else
          for (final account in students)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _StudentAccountCard(
                account: account,
                selected: selected?.id == account.id,
                onTap: () => onSelect(account),
                onEdit: () => onEdit(account),
                onDelete: () => onDelete(account),
              ),
            ),
      ],
    );
  }
}

class _StudentAccountCard extends StatelessWidget {
  const _StudentAccountCard({
    required this.account,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final AccountSummary account;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final avatar = AppAssets
        .profileAvatars[account.avatarIndex % AppAssets.profileAvatars.length];
    return AppCard(
      onTap: onTap,
      color: selected ? AppColors.leafSoft : Colors.white,
      borderColor: selected ? AppColors.leaf : AppColors.border,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: AppColors.sunSoft,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              avatar,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => CircleAvatar(
                backgroundColor: AppColors.skySoft,
                child: Text(
                  account.initial,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        account.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (selected) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.leafDeep,
                        size: 18,
                      ),
                    ],
                  ],
                ),
                Text(
                  '${schoolGradeLabel(account.schoolGrade)} • المستوى ${ArabicNumbers.formatInt(account.currentLevel)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  'أكمل ${ArabicNumbers.formatInt(account.completedLevels)} من ١٠٠ مستوى',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.leafDeep,
                      ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'خيارات الطالب',
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.edit_rounded),
                  title: Text('تعديل البيانات'),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.person_off_rounded),
                  title: Text('حذف الحساب'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressTab extends ConsumerWidget {
  const _ProgressTab({required this.account});

  final AccountSummary? account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = account?.profile;
    if (profile == null) {
      return const EmptyState(
        title: 'اختر طالباً',
        message: 'اختر طالباً من تبويب الطلاب لعرض تقدمه.',
        icon: Icons.insights_outlined,
      );
    }
    final overviewAsync = ref.watch(studentLevelOverviewProvider(profile.id));
    final stats =
        ref.watch(profileStatsProvider).valueOrNull ?? ProfileStats.empty;
    final facts =
        ref.watch(factMasteryProvider).valueOrNull ?? const <FactMastery>[];
    final history =
        ref.watch(examHistoryProvider).valueOrNull ?? const <ExamRecord>[];
    final weak = facts.where((fact) => fact.isWeak).take(8).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        _StudentSummaryCard(account: account!),
        const SizedBox(height: 14),
        overviewAsync.when(
          loading: () => const AppCard(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => ErrorRetryView(
            message: 'تعذر تحميل تقدم المستويات.',
            onRetry: () =>
                ref.invalidate(studentLevelOverviewProvider(profile.id)),
          ),
          data: (overview) => _LevelProgressCard(overview: overview),
        ),
        const SizedBox(height: 14),
        _AttemptSummaryCard(stats: stats, history: history),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.9,
          children: [
            _ParentStat(
              label: 'الاختبارات',
              value: ArabicNumbers.formatInt(stats.examsCount),
              icon: Icons.school_rounded,
              color: AppColors.sky,
            ),
            _ParentStat(
              label: 'الدقة',
              value: ArabicNumbers.formatPercent(stats.accuracy),
              icon: Icons.track_changes_rounded,
              color: AppColors.leaf,
            ),
            _ParentStat(
              label: 'وقت التعلم',
              value: ArabicNumbers.formatDuration(stats.learningSeconds),
              icon: Icons.timer_rounded,
              color: AppColors.purple,
            ),
            _ParentStat(
              label: 'الإجابات الصحيحة',
              value: ArabicNumbers.formatInt(stats.correctAnswers),
              icon: Icons.check_circle_rounded,
              color: AppColors.coral,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'نقاط تحتاج إلى تدريب',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        AppCard(
          child: weak.isEmpty
              ? Text(
                  'لا توجد نقاط ضعف واضحة حالياً.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                )
              : Column(
                  children: [
                    for (final fact in weak)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                fact.label,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              '${ArabicNumbers.formatInt(fact.correct)}/${ArabicNumbers.formatInt(fact.attempts)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 70,
                              child: ProgressPill(
                                value: fact.accuracy / 100,
                                color: AppColors.coral,
                                height: 7,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(
                'آخر النتائج',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (history.isEmpty)
              Text(
                'لا توجد محاولات',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
              )
            else
              TextButton(
                onPressed: () => _showAllExams(context, ref, history),
                child: Text(
                  'عرض الكل (${ArabicNumbers.formatInt(history.length)})',
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (history.isEmpty)
          AppCard(
            child: Text(
              'لا توجد نتائج مسجلة بعد.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          for (final exam in history.take(8))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ExamCard(
                exam: exam,
                onTap: () => _showExamDetails(context, ref, exam),
              ),
            ),
      ],
    );
  }
}

class _AttemptSummaryCard extends StatelessWidget {
  const _AttemptSummaryCard({required this.stats, required this.history});

  final ProfileStats stats;
  final List<ExamRecord> history;

  @override
  Widget build(BuildContext context) {
    final latest = history.isEmpty ? null : history.first;
    final latestAccuracy = latest == null || latest.total == 0
        ? 0.0
        : latest.correct / latest.total * 100;
    return AppCard(
      color: AppColors.skySoft,
      borderColor: AppColors.sky.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_rounded, color: AppColors.skyDeep),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ملخص المحاولات',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (latest != null)
                Text(
                  ArabicNumbers.formatDateTime(latest.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryChip(
                label: 'اختبارات اليوم',
                value: ArabicNumbers.formatInt(stats.todayExamsCount),
                color: AppColors.coral,
              ),
              _SummaryChip(
                label: 'متوسط الدقة',
                value: ArabicNumbers.formatPercent(stats.accuracy),
                color: AppColors.skyDeep,
              ),
              _SummaryChip(
                label: 'أفضل نتيجة',
                value: ArabicNumbers.formatPercent(stats.bestAccuracy),
                color: AppColors.leafDeep,
              ),
              _SummaryChip(
                label: 'آخر نتيجة',
                value: ArabicNumbers.formatPercent(latestAccuracy),
                color: AppColors.sunDeep,
              ),
            ],
          ),
          if (history.isNotEmpty) ...[
            const SizedBox(height: 12),
            _AttemptTrend(exams: history),
          ],
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}

class _AttemptTrend extends StatelessWidget {
  const _AttemptTrend({required this.exams});

  final List<ExamRecord> exams;

  @override
  Widget build(BuildContext context) {
    final recent = exams.take(7).toList().reversed.toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تطور آخر المحاولات',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mutedForeground,
              ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 72,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final exam in recent)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ArabicNumbers.formatPercent(
                            exam.total == 0
                                ? 0
                                : exam.correct / exam.total * 100,
                          ),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 10,
                                    color: AppColors.mutedForeground,
                                  ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          height: 8 +
                              (44 *
                                  (exam.total == 0
                                      ? 0
                                      : exam.correct / exam.total)),
                          decoration: BoxDecoration(
                            color: _trendColor(exam),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _trendColor(ExamRecord exam) {
    final accuracy = exam.total == 0 ? 0.0 : exam.correct / exam.total * 100;
    if (accuracy >= 80) return AppColors.leaf;
    if (accuracy >= 50) return AppColors.sunDeep;
    return AppColors.coral;
  }
}

class _StudentSummaryCard extends StatelessWidget {
  const _StudentSummaryCard({required this.account});

  final AccountSummary account;

  @override
  Widget build(BuildContext context) {
    final avatar = AppAssets
        .profileAvatars[account.avatarIndex % AppAssets.profileAvatars.length];
    return AppCard(
      color: AppColors.skySoft,
      borderColor: AppColors.sky.withValues(alpha: 0.22),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              avatar,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => CircleAvatar(
                backgroundColor: AppColors.skySoft,
                child: Text(
                  account.initial,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.displayName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '${schoolGradeLabel(account.schoolGrade)} • المستوى الحالي ${ArabicNumbers.formatInt(account.currentLevel)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  'أكمل ${ArabicNumbers.formatInt(account.completedLevels)} من ١٠٠ مستوى',
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

class _LevelProgressCard extends StatelessWidget {
  const _LevelProgressCard({required this.overview});

  final StudentLevelOverview overview;

  @override
  Widget build(BuildContext context) {
    final completed = overview.views
        .where((view) => view.status == LearningLevelStatus.completed)
        .toList();
    final incomplete = overview.views
        .where((view) => view.status != LearningLevelStatus.completed)
        .toList();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'تقدم المستويات التعليمية',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                '${ArabicNumbers.formatInt(overview.completedCount)}/${ArabicNumbers.formatInt(overview.totalLevels)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.leafDeep,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ProgressPill(value: overview.completionRatio, color: AppColors.leaf),
          const SizedBox(height: 8),
          Text(
            overview.nextIncomplete == null
                ? 'أكمل الطالب جميع المستويات.'
                : 'المستوى التالي: ${ArabicNumbers.formatInt(overview.nextIncomplete!.level.levelNumber)} — ${overview.nextIncomplete!.level.title}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
          ),
          const SizedBox(height: 12),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            initiallyExpanded: incomplete.isNotEmpty,
            title: Text(
              'المستويات غير المكتملة (${ArabicNumbers.formatInt(incomplete.length)})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            children: [
              _LevelNumberWrap(views: incomplete),
            ],
          ),
          const Divider(),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(
              'المستويات المكتملة (${ArabicNumbers.formatInt(completed.length)})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            children: [
              if (completed.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 10),
                  child: Text(
                    'لم يكمل الطالب أي مستوى بعد.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                  ),
                )
              else
                _LevelNumberWrap(views: completed, completed: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelNumberWrap extends StatelessWidget {
  const _LevelNumberWrap({required this.views, this.completed = false});

  final List<StudentLevelView> views;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final view in views)
            Tooltip(
              message: view.level.title,
              child: Container(
                width: 38,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: completed ? AppColors.leafSoft : AppColors.muted,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: completed ? AppColors.leaf : AppColors.border,
                  ),
                ),
                child: Text(
                  ArabicNumbers.formatInt(view.level.levelNumber),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: completed ? AppColors.leafDeep : AppColors.ink,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ManageTab extends StatelessWidget {
  const _ManageTab({
    required this.account,
    required this.onAdd,
    required this.onEdit,
    required this.onChangePassword,
    required this.onChangeParentPassword,
    required this.onBackupRestore,
    required this.onDelete,
    required this.onResetProgress,
    required this.onLogout,
  });

  final AccountSummary? account;
  final VoidCallback onAdd;
  final ValueChanged<AccountSummary> onEdit;
  final ValueChanged<AccountSummary> onChangePassword;
  final VoidCallback onChangeParentPassword;
  final VoidCallback onBackupRestore;
  final ValueChanged<AccountSummary> onDelete;
  final ValueChanged<AccountSummary> onResetProgress;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        Text(
          'إدارة الطلاب',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        AppCard(
          child: Column(
            children: [
              _ManageTile(
                icon: Icons.person_add_alt_1_rounded,
                title: 'إضافة طالب جديد',
                subtitle: 'الاسم، الصف، الشخصية، وكلمة المرور',
                onTap: onAdd,
              ),
              if (account != null) ...[
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_rounded),
                  title: Text(account!.displayName),
                  subtitle: Text(schoolGradeLabel(account!.schoolGrade)),
                ),
                const Divider(),
                _ManageTile(
                  icon: Icons.edit_rounded,
                  title: 'تعديل بيانات الطالب',
                  subtitle: 'الاسم، الصف، والشخصية',
                  onTap: () => onEdit(account!),
                ),
                const Divider(),
                _ManageTile(
                  icon: Icons.key_rounded,
                  title: 'تغيير كلمة مرور الطالب',
                  subtitle: 'تعيين كلمة مرور جديدة دون كلمة المرور القديمة',
                  onTap: () => onChangePassword(account!),
                ),
                const Divider(),
                _ManageTile(
                  icon: Icons.restart_alt_rounded,
                  title: 'إعادة تعيين تقدم الطالب',
                  subtitle: 'حذف النجوم والنتائج والمستويات المكتملة',
                  onTap: () => onResetProgress(account!),
                ),
                const Divider(),
                _ManageTile(
                  icon: Icons.person_off_rounded,
                  title: 'حذف حساب الطالب',
                  subtitle: 'إخفاء الحساب مع الاحتفاظ بالنتائج',
                  color: AppColors.coralDeep,
                  onTap: () => onDelete(account!),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'حساب ولي الأمر',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        AppCard(
          child: Column(
            children: [
              _ManageTile(
                icon: Icons.password_rounded,
                title: 'تغيير كلمة مرور ولي الأمر',
                subtitle: 'يتطلب إدخال كلمة المرور الحالية',
                onTap: onChangeParentPassword,
              ),
              const Divider(),
              _ManageTile(
                icon: Icons.backup_rounded,
                title: 'نسخ احتياطي واستعادة',
                subtitle: 'احفظ قاعدة البيانات محلياً قبل التحديث أو الاستعادة',
                onTap: onBackupRestore,
              ),
              const Divider(),
              _ManageTile(
                icon: Icons.tune_rounded,
                title: 'إعدادات التطبيق',
                subtitle: 'الصوت، النطق، سهولة القراءة، والصعوبة',
                onTap: () => context.push('/settings'),
              ),
              const Divider(),
              _ManageTile(
                icon: Icons.logout_rounded,
                title: 'تسجيل الخروج',
                subtitle: 'العودة إلى شاشة اختيار الحساب',
                color: AppColors.coralDeep,
                onTap: onLogout,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ManageTile extends StatelessWidget {
  const _ManageTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color = AppColors.ink,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_left_rounded),
      onTap: onTap,
    );
  }
}

class _ReportsTab extends ConsumerStatefulWidget {
  const _ReportsTab({required this.account, required this.onLogout});

  final AccountSummary? account;
  final VoidCallback onLogout;

  @override
  ConsumerState<_ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends ConsumerState<_ReportsTab> {
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    final profile = account?.profile;
    final stats =
        ref.watch(profileStatsProvider).valueOrNull ?? ProfileStats.empty;
    final exams =
        ref.watch(examHistoryProvider).valueOrNull ?? const <ExamRecord>[];
    final overview = profile == null
        ? null
        : ref.watch(studentLevelOverviewProvider(profile.id)).valueOrNull;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      children: [
        Text(
          'التقارير',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        if (account == null || profile == null)
          AppCard(
            child: Text(
              'اختر طالباً من تبويب الطلاب لتصدير تقريره.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else ...[
          AppCard(
            color: AppColors.skySoft,
            borderColor: AppColors.sky.withValues(alpha: 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '${ArabicNumbers.formatInt(stats.examsCount)} اختبار • دقة ${ArabicNumbers.formatPercent(stats.accuracy)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                if (overview != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${ArabicNumbers.formatInt(overview.completedCount)} مستوى مكتمل من ${ArabicNumbers.formatInt(overview.totalLevels)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.leafDeep,
                        ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                _ManageTile(
                  icon: Icons.data_object_rounded,
                  title: 'تصدير تقرير JSON',
                  subtitle: 'نسخة كاملة من بيانات الطالب',
                  onTap: _exporting
                      ? () {}
                      : () => _export(
                            json: true,
                            profile: profile,
                            stats: stats,
                            exams: exams,
                          ),
                ),
                const Divider(),
                _ManageTile(
                  icon: Icons.table_chart_rounded,
                  title: 'تصدير سجل الاختبارات CSV',
                  subtitle: 'ملف مناسب لجداول البيانات',
                  onTap: _exporting
                      ? () {}
                      : () => _export(
                            json: false,
                            profile: profile,
                            stats: stats,
                            exams: exams,
                          ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        Text(
          'التطبيق',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        AppCard(
          child: Column(
            children: [
              _ManageTile(
                icon: Icons.tune_rounded,
                title: 'إعدادات التطبيق',
                subtitle: 'الصوت، النطق، سهولة القراءة، والصعوبة',
                onTap: () => context.push('/settings'),
              ),
              const Divider(),
              _ManageTile(
                icon: Icons.logout_rounded,
                title: 'تسجيل الخروج',
                subtitle: 'العودة إلى شاشة اختيار الحساب',
                color: AppColors.coralDeep,
                onTap: widget.onLogout,
              ),
            ],
          ),
        ),
      ],
    );
  }


  Future<void> _export({
    required bool json,
    required Profile profile,
    required ProfileStats stats,
    required List<ExamRecord> exams,
  }) async {
    setState(() => _exporting = true);
    try {
      final file = json
          ? await ReportExporter.exportJson(
              profile: profile,
              stats: stats,
              exams: exams,
            )
          : await ReportExporter.exportCsv(profile: profile, exams: exams);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم تصدير التقرير'),
          content: SelectableText('تم حفظ الملف في:\n${file.path}'),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: file.path));
                Navigator.of(context).pop();
              },
              child: const Text('نسخ المسار'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('حسنًا'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (mounted) {
        showAppSnack(context, 'تعذر تصدير التقرير.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.exam, required this.onTap});

  final ExamRecord exam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.skySoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: AppColors.skyDeep,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${ArabicNumbers.formatDateTime(exam.createdAt)} • ${ArabicNumbers.formatInt(exam.correct)}/${ArabicNumbers.formatInt(exam.total)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
          Text(
            ArabicNumbers.formatPercent(
              exam.total == 0 ? 0 : exam.correct / exam.total * 100,
            ),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.leafDeep,
                ),
          ),
        ],
      ),
    );
  }
}

class _ParentStat extends StatelessWidget {
  const _ParentStat({
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
      padding: const EdgeInsets.all(12),
      borderColor: color.withValues(alpha: 0.16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color,
                      ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 11,
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

void _showAllExams(
  BuildContext context,
  WidgetRef ref,
  List<ExamRecord> exams,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      return SizedBox(
        height: MediaQuery.of(sheetContext).size.height * 0.85,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'جميع المحاولات',
                      style: Theme.of(sheetContext).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    '${ArabicNumbers.formatInt(exams.length)} محاولة',
                    style: Theme.of(sheetContext).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                  ),
                  IconButton(
                    tooltip: 'إغلاق',
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                itemCount: exams.length,
                itemBuilder: (itemContext, index) {
                  final exam = exams[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ExamCard(
                      exam: exam,
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        _showExamDetails(context, ref, exam);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _showExamDetails(
  BuildContext context,
  WidgetRef ref,
  ExamRecord exam,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exam.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              '${ArabicNumbers.formatDateTime(exam.createdAt)} • ${ArabicNumbers.formatDuration(exam.durationSeconds)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'البداية ${ArabicNumbers.formatDateTime(exam.startedAt ?? exam.createdAt.subtract(Duration(seconds: exam.durationSeconds)))} • الحالة ${exam.status == 'completed' ? 'مكتمل' : exam.status}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
            const SizedBox(height: 14),
            Flexible(
              child: FutureBuilder<List<AnswerRecord>>(
                future: ref.read(databaseProvider).getAnswersForExam(exam.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final answers = snapshot.data!;
                  if (answers.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('لا توجد تفاصيل محفوظة لهذا الاختبار.'),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: answers.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final answer = answers[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          answer.isCorrect
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: answer.isCorrect
                              ? AppColors.leafDeep
                              : AppColors.coralDeep,
                        ),
                        title: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(answer.questionText),
                        ),
                        subtitle: Text(
                          'إجابة الطالب: ${answer.childAnswer ?? 'لم يجب'} • الصحيحة: ${answer.correctAnswer}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _StudentFormSheet extends ConsumerStatefulWidget {
  const _StudentFormSheet({this.account});

  final AccountSummary? account;

  @override
  ConsumerState<_StudentFormSheet> createState() => _StudentFormSheetState();
}

class _StudentFormSheetState extends ConsumerState<_StudentFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  late int _grade;
  late int _avatarIndex;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    _nameController = TextEditingController(text: account?.displayName ?? '');
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _grade = account?.schoolGrade ?? 1;
    _avatarIndex = account?.avatarIndex ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final accounts = ref.read(accountsProvider.notifier);
      final account = widget.account;
      final saved = account == null
          ? await accounts.createStudent(
              name: _nameController.text,
              schoolGrade: _grade,
              avatarIndex: _avatarIndex,
              password: _passwordController.text,
            )
          : await accounts.updateStudent(
              account: account,
              name: _nameController.text,
              schoolGrade: _grade,
              avatarIndex: _avatarIndex,
            );
      if (!mounted) return;
      ref.read(audioServiceProvider).play(SoundEffect.celebration);
      Navigator.of(context).pop(saved);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = error is ArgumentError
            ? (error.message?.toString() ?? 'تعذر حفظ البيانات.')
            : 'تعذر حفظ البيانات. حاول مرة أخرى.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEditing ? 'تعديل بيانات الطالب' : 'إضافة طالب جديد',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'إغلاق',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                autofocus: !_isEditing,
                maxLength: 24,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'اسم الطالب',
                  prefixIcon: Icon(Icons.person_rounded),
                  counterText: '',
                ),
                validator: AccountValidators.studentName,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _grade,
                decoration: const InputDecoration(
                  labelText: 'الصف الدراسي',
                  prefixIcon: Icon(Icons.school_rounded),
                ),
                items: [
                  for (var grade = 1; grade <= 12; grade++)
                    DropdownMenuItem(
                      value: grade,
                      child: Text(schoolGradeLabel(grade)),
                    ),
                ],
                onChanged: (value) => setState(() => _grade = value ?? 1),
              ),
              const SizedBox(height: 14),
              Text(
                'اختر الشخصية',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  AppAssets.profileAvatars.length,
                  (index) {
                    final selected = index == _avatarIndex;
                    return InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () => setState(() => _avatarIndex = index),
                      child: Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.skySoft : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? AppColors.sky : AppColors.border,
                            width: selected ? 2.5 : 1,
                          ),
                        ),
                        child: Image.asset(
                          AppAssets.profileAvatars[index],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.emoji_nature_rounded),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (!_isEditing) ...[
                const SizedBox(height: 16),
                AppCard(
                  borderColor: AppColors.sky.withValues(alpha: 0.25),
                  child: Row(
                    children: [
                      const Icon(Icons.key_rounded, color: AppColors.skyDeep),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'سيتم تعيين كلمة مرور تلقائية: الطالب ١ = 111111، الطالب ٢ = 222222، وهكذا.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.mutedForeground,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.coralDeep,
                      ),
                ),
              ],
              const SizedBox(height: 18),
              PressButton(
                onPressed: _saving ? null : _save,
                expanded: true,
                color: AppColors.leafDeep,
                minHeight: 54,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isEditing ? 'حفظ التعديلات' : 'إضافة الطالب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordDialog extends ConsumerStatefulWidget {
  const _ChangePasswordDialog({
    required this.account,
    this.requireCurrent = false,
  });

  final AccountSummary account;
  final bool requireCurrent;

  @override
  ConsumerState<_ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    if (widget.requireCurrent) {
      final result = await ref.read(authProvider.notifier).changePassword(
            userId: widget.account.id,
            currentPassword: _currentController.text,
            newPassword: _passwordController.text,
          );
      if (!mounted) return;
      if (result.failure != null) {
        setState(() {
          _saving = false;
          _error = result.failure!.message;
        });
        return;
      }
    } else {
      try {
        await ref.read(accountsProvider.notifier).resetStudentPassword(
              userId: widget.account.id,
              password: _passwordController.text,
            );
      } catch (error) {
        if (!mounted) return;
        setState(() {
          _saving = false;
          _error = error is ArgumentError
              ? (error.message?.toString() ?? 'كلمة المرور غير صالحة.')
              : 'تعذر تغيير كلمة المرور.';
        });
        return;
      }
    }
    if (!mounted) return;
    ref.read(audioServiceProvider).play(SoundEffect.star);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isParent = widget.account.isParent;
    return AlertDialog(
      title: Text(
        isParent
            ? 'تغيير كلمة مرور ولي الأمر'
            : 'تغيير كلمة مرور ${widget.account.displayName}',
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.requireCurrent) ...[
                TextFormField(
                  controller: _currentController,
                  autofocus: true,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور الحالية',
                    prefixIcon: Icon(Icons.lock_rounded),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'كلمة المرور الحالية مطلوبة.'
                      : null,
                ),
                const SizedBox(height: 10),
              ],
              TextFormField(
                controller: _passwordController,
                autofocus: !widget.requireCurrent,
                obscureText: _obscure,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  helperText: '٦ أحرف على الأقل',
                  prefixIcon: const Icon(Icons.key_rounded),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                  ),
                ),
                validator: AccountValidators.password,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'تأكيد كلمة المرور',
                  prefixIcon: Icon(Icons.verified_user_rounded),
                ),
                validator: (value) => AccountValidators.confirmPassword(
                  value,
                  _passwordController.text,
                ),
                onFieldSubmitted: (_) => _submit(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.coralDeep,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('حفظ'),
        ),
      ],
    );
  }
}

class _BackupRestoreSheet extends ConsumerStatefulWidget {
  const _BackupRestoreSheet({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_BackupRestoreSheet> createState() =>
      _BackupRestoreSheetState();
}

class _BackupRestoreSheetState extends ConsumerState<_BackupRestoreSheet> {
  bool _busy = false;
  List<BackupInfo> _backups = const [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final backups = await DataBackupService.listBackups();
    if (!mounted) return;
    setState(() {
      _backups = backups;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      minChildSize: 0.45,
      builder: (context, controller) => Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              'نسخ احتياطي واستعادة',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'النسخة الاحتياطية تحفظ قاعدة البيانات المحلية (الطلاب، النتائج، المستويات). استخدمها قبل تحديث التطبيق. استعادة نسخة تستبدل البيانات الحالية بعد إعادة تشغيل التطبيق.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PressButton(
                  onPressed: _busy ? null : _createBackup,
                  minHeight: 44,
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('إنشاء نسخة احتياطية'),
                ),
                PressButton(
                  onPressed: _busy ? null : _load,
                  color: AppColors.skySoft,
                  foregroundColor: AppColors.skyDeep,
                  minHeight: 44,
                  child: const Text('تحديث القائمة'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (!_loaded)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_backups.isEmpty)
              AppCard(
                child: Text(
                  'لا توجد نسخ احتياطية بعد. أنشئ نسخة قبل تحديث التطبيق للحفاظ على بيانات الطلاب.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else
              for (final backup in _backups)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          backup.fileName,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ArabicNumbers.formatDateTime(backup.createdAt)} • ${_formatBytes(backup.sizeBytes)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.mutedForeground,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed:
                                  _busy ? null : () => _copyPath(backup.path),
                              child: const Text('نسخ المسار'),
                            ),
                            FilledButton(
                              onPressed: _busy ? null : () => _restore(backup),
                              child: const Text('استعادة'),
                            ),
                            TextButton(
                              onPressed: _busy ? null : () => _delete(backup),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.coralDeep,
                              ),
                              child: const Text('حذف'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _createBackup() async {
    setState(() => _busy = true);
    try {
      final backup = await DataBackupService.createBackup(
        ref.read(databaseProvider),
      );
      if (!mounted) return;
      await _load();
      if (!mounted) return;
      await Clipboard.setData(ClipboardData(text: backup.path));
      if (!mounted) return;
      showAppSnack(context, 'تم إنشاء النسخة الاحتياطية ونسخ مسارها.');
    } catch (error) {
      if (mounted) {
        showAppSnack(
          context,
          error is StateError ? error.message : 'تعذر إنشاء النسخة الاحتياطية.',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore(BackupInfo backup) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'استعادة النسخة الاحتياطية؟',
      message:
          'سيتم استبدال بيانات التطبيق الحالية بهذه النسخة عند إعادة تشغيل التطبيق. تأكد من صحة النسخة. لا يمكن التراجع بعد إعادة التشغيل.',
      confirmLabel: 'تجهيز الاستعادة',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    try {
      await DataBackupService.checkpoint(ref.read(databaseProvider));
      await DataBackupService.scheduleRestoreOnNextLaunch(backup.path);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('أعد تشغيل التطبيق'),
          content: const Text(
            'تم تجهيز الاستعادة. أغلق التطبيق تماماً ثم افتحه مرة أخرى لتطبيق النسخة الاحتياطية.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (mounted) {
        showAppSnack(context, 'تعذر تجهيز الاستعادة.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete(BackupInfo backup) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'حذف النسخة الاحتياطية؟',
      message: backup.fileName,
      confirmLabel: 'حذف',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    try {
      await DataBackupService.deleteBackup(backup.path);
      await _load();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copyPath(String path) async {
    await Clipboard.setData(ClipboardData(text: path));
    if (mounted) showAppSnack(context, 'تم نسخ المسار.');
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/enums.dart';
import '../../shared/widgets/app_widgets.dart';
import '../login/login_screen.dart';
import 'parent_lan_section.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _testingVoice = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    if (auth == null) return const LoginScreen();
    final settings = ref.watch(settingsProvider);
    final tts = ref.read(ttsServiceProvider);
    return PlayfulScaffold(
      accent: AppColors.sky,
      appBar: AppBar(
        title: const Text('الإعدادات'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          _SectionTitle(
            title: 'الصوت والنطق',
            icon: Icons.volume_up_rounded,
            color: AppColors.sky,
          ),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('المؤثرات الصوتية'),
                  subtitle: const Text('أصوات الأزرار والنجاح والمكافآت'),
                  value: settings.soundEnabled,
                  onChanged: (value) => ref
                      .read(settingsProvider.notifier)
                      .setSoundEnabled(value),
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('النطق الصوتي'),
                  subtitle: const Text('قراءة الأسئلة والتعليمات بصوت عربي'),
                  value: settings.ttsEnabled,
                  onChanged: (value) =>
                      ref.read(settingsProvider.notifier).setTtsEnabled(value),
                ),
                if (settings.ttsEnabled) ...[
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('سرعة النطق'),
                    subtitle: Text(
                      settings.speechRate < 0.4
                          ? 'هادئة'
                          : settings.speechRate < 0.58
                              ? 'متوسطة'
                              : 'سريعة',
                    ),
                    trailing: PressButton(
                      onPressed: _testingVoice ? null : _testVoice,
                      color: AppColors.skySoft,
                      foregroundColor: AppColors.skyDeep,
                      minHeight: 38,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: _testingVoice
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('تجربة'),
                    ),
                  ),
                  Slider(
                    value: settings.speechRate.clamp(0.25, 0.7),
                    min: 0.25,
                    max: 0.7,
                    divisions: 9,
                    label: settings.speechRate.toStringAsFixed(2),
                    onChanged: (value) => ref
                        .read(settingsProvider.notifier)
                        .setSpeechRate(value),
                  ),
                  if (tts.initialized && !tts.available)
                    _InfoNote(
                      text: tts.unavailableReason ??
                          'النطق غير متاح على هذا الجهاز. بقية الأنشطة تعمل.',
                      color: AppColors.sunSoft,
                      icon: Icons.info_outline_rounded,
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'سهولة القراءة',
            icon: Icons.accessibility_new_rounded,
            color: AppColors.purple,
          ),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('تكبير الخط'),
                  subtitle: const Text('نصوص أكبر لسهولة القراءة'),
                  value: settings.largeText,
                  onChanged: (value) =>
                      ref.read(settingsProvider.notifier).setLargeText(value),
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('تباين عالٍ'),
                  subtitle: const Text('ألوان أوضح وحدود أقوى'),
                  value: settings.highContrast,
                  onChanged: (value) => ref
                      .read(settingsProvider.notifier)
                      .setHighContrast(value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'التعلم',
            icon: Icons.auto_awesome_rounded,
            color: AppColors.leaf,
          ),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('المؤقت في التمارين'),
                  subtitle: const Text('عرض وقت التمرين أثناء الحل'),
                  value: settings.timersEnabled,
                  onChanged: (value) => ref
                      .read(settingsProvider.notifier)
                      .setTimersEnabled(value),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('هدف التعلم اليومي'),
                  subtitle: Text(
                    '${ArabicNumbers.formatInt(settings.dailyGoalMinutes)} دقيقة',
                  ),
                ),
                Slider(
                  value: settings.dailyGoalMinutes.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 11,
                  label:
                      '${ArabicNumbers.formatInt(settings.dailyGoalMinutes)} دقيقة',
                  onChanged: (value) => ref
                      .read(settingsProvider.notifier)
                      .setDailyGoalMinutes(value.round()),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الصعوبة الافتراضية',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final difficulty in Difficulty.values)
                      ChoiceChip(
                        label: Text(difficulty.label),
                        selected: settings.defaultDifficulty == difficulty,
                        onSelected: (_) => ref
                            .read(settingsProvider.notifier)
                            .setDefaultDifficulty(difficulty),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: 'الحساب',
            icon: Icons.account_circle_rounded,
            color: AppColors.coral,
          ),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.person_rounded,
                    color: AppColors.coralDeep,
                  ),
                  title: Text(auth.account.displayName),
                  subtitle: Text(auth.account.role.label),
                ),
                const Divider(),
                if (!auth.isParent)
                  FutureBuilder<bool>(
                    future: ref.read(biometricServiceProvider).isBiometricAvailable(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('إعدادات البصمة'),
                          subtitle: Text('جارٍ التحميل...'),
                          trailing: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      
                      final biometricAvailable = snapshot.data ?? false;
                      if (!biometricAvailable) return const SizedBox.shrink();
                      
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('إعدادات البصمة'),
                        subtitle: const Text('تفعيل/تعطيل تسجيل الدخول بالبصمة'),
                        trailing: const Icon(
                          Icons.fingerprint_rounded,
                          color: AppColors.coralDeep,
                        ),
                        onTap: () => context.push(
                          '/settings/biometric?userId=${auth.account.id}',
                        ),
                      );
                    },
                  ),
                if (!auth.isParent) const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('تسجيل الخروج'),
                  subtitle: const Text('العودة إلى شاشة اختيار الحساب'),
                  trailing: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.coralDeep,
                  ),
                  onTap: _logout,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (auth.isParent) ...[
            _SectionTitle(
              title: 'الاتصال بهاتف ولي الأمر',
              icon: Icons.wifi_tethering_rounded,
              color: AppColors.sky,
            ),
            const ParentLanSection(),
            const SizedBox(height: 20),
          ],
          _SectionTitle(
            title: 'حول التطبيق',
            icon: Icons.info_rounded,
            color: AppColors.sunDeep,
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أبطال الحساب',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'الإصدار ١.٠.٠',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'تطبيق تعليمي عربي لبناء طلاقة الحساب الذهني من خلال تمارين قصيرة وممتعة.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'تسجيل الخروج؟',
      message: 'سيتم قفل الحساب والعودة إلى شاشة الدخول.',
      confirmLabel: 'تسجيل الخروج',
    );
    if (!confirmed || !mounted) return;
    await ref.read(authProvider.notifier).logout();
    if (mounted) context.go('/login');
  }

  Future<void> _testVoice() async {
    final tts = ref.read(ttsServiceProvider);
    setState(() => _testingVoice = true);
    try {
      await tts.initialize(speechRate: ref.read(settingsProvider).speechRate);
      if (!tts.available) {
        if (mounted) {
          showAppSnack(
            context,
            tts.unavailableReason ?? 'النطق غير متاح على هذا الجهاز.',
            isError: true,
          );
        }
        return;
      }
      await tts.speak('أهلًا بك يا بطل! هيا نتدرب على الحساب.');
    } finally {
      if (mounted) setState(() => _testingVoice = false);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({
    required this.text,
    required this.color,
    required this.icon,
  });

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.ink),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

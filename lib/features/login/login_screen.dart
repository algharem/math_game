import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/auth_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../core/services/biometric_service.dart' show BiometricType;

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    return PlayfulScaffold(
      accent: AppColors.leaf,
      body: accounts.when(
        loading: () => const LoadingView(message: 'نجهّز قائمة الأبطال...'),
        error: (error, stackTrace) => ErrorRetryView(
          message: 'تعذر تحميل قائمة الحسابات.',
          onRetry: () => ref.invalidate(accountsProvider),
        ),
        data: (items) {
          final students = items.where((account) => account.isStudent).toList();
          final parent = items.where((account) => account.isParent).firstOrNull;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            children: [
              MascotBubble(
                asset: AppAssets.mascotHappy,
                message:
                    'مرحبًا بك في أبطال الحساب! اختر حسابك وأدخل كلمة المرور.',
                onSpeak: () => ref.read(ttsServiceProvider).speak(
                      'مرحبًا بك في أبطال الحساب! اختر حسابك وأدخل كلمة المرور.',
                    ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Text(
                    'من يلعب اليوم؟',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  if (students.isNotEmpty)
                    Text(
                      '${ArabicNumbers.formatInt(students.length)} طلاب',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                    ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => _loginWithUsername(context, ref),
                  icon: const Icon(Icons.key_rounded, size: 18),
                  label: const Text('الدخول باسم المستخدم'),
                ),
              ),
              const SizedBox(height: 4),
              if (students.isEmpty)
                AppCard(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        size: 44,
                        color: AppColors.skyDeep,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'لا يوجد طلاب بعد',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ادخل بحساب ولي الأمر لإضافة أول طالب.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                      ),
                    ],
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: students.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 260,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.96,
                  ),
                  itemBuilder: (context, index) {
                    final account = students[index];
                    return _StudentLoginCard(
                      account: account,
                      onTap: () => _login(context, ref, account),
                    );
                  },
                ),
              if (parent != null) ...[
                const SizedBox(height: 24),
                Text(
                  'حساب ولي الأمر',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                _ParentLoginCard(
                  account: parent,
                  onTap: () => _login(context, ref, parent),
                ),
              ],
              const SizedBox(height: 20),
              const _RemoteParentCard(),
            ],
          );
        },
      ),
    );
  }

  Future<void> _loginWithUsername(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final session = await showDialog<AuthSession>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _UsernameLoginDialog(),
    );
    if (session == null || !context.mounted) return;
    await _completeLogin(context, ref, session);
  }

  Future<void> _login(
    BuildContext context,
    WidgetRef ref,
    AccountSummary account,
  ) async {
    ref.read(audioServiceProvider).play(SoundEffect.tap);

    // Capture navigator before any async operations so the dialog does
    // not depend on a possibly unmounted BuildContext after awaits.
    final navigator = Navigator.of(context, rootNavigator: true);

    // Check if biometric is available and enabled for this user
    final biometricService = ref.read(biometricServiceProvider);
    final biometricAvailable = await biometricService.isBiometricAvailable();
    final biometricEnabled =
        await biometricService.isBiometricEnabled(account.id);
    final recentlyAuthenticated =
        await biometricService.wasRecentlyAuthenticated(account.id);

    // Show biometric option if available, enabled, and not recently authenticated
    if (biometricAvailable && biometricEnabled && !recentlyAuthenticated) {
      // `navigator` was captured before the awaits above; the dialog is
      // pushed on that stable NavigatorState regardless of whether the
      // original widget unmounted mid-flow.
      final useBiometric = await navigator.push<bool>(
        PageRouteBuilder<bool>(
          opaque: false,
          barrierDismissible: true,
          pageBuilder: (context, animation, secondaryAnimation) =>
              _BiometricChoiceDialog(account: account),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );

      if (useBiometric == true && context.mounted) {
        await _loginWithBiometric(context, ref, account);
        return;
      }
    }

    // Fall back to password login if the widget is still mounted
    if (context.mounted) {
      await _loginWithPassword(context, ref, account);
    }
  }

  Future<void> _loginWithPassword(
    BuildContext context,
    WidgetRef ref,
    AccountSummary account,
  ) async {
    final session = await showDialog<AuthSession>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PasswordLoginDialog(account: account),
    );
    if (session == null || !context.mounted) return;
    await _completeLogin(context, ref, session);
  }

  Future<void> _loginWithBiometric(
    BuildContext context,
    WidgetRef ref,
    AccountSummary account,
  ) async {
    final biometricService = ref.read(biometricServiceProvider);
    final authenticated = await biometricService.authenticate(
      userId: account.id,
      localizedReason: 'تسجيل دخول ${account.displayName}',
    );

    if (!authenticated) {
      // If biometric fails, fall back to password if context is still valid
      if (context.mounted) {
        await _loginWithPassword(context, ref, account);
      }
      return;
    }

    final result = await ref.read(authProvider.notifier).loginWithBiometric(
          userId: account.id,
        );

    if (result.session == null) {
      if (context.mounted) {
        showAppSnack(
          context,
          'تعذر تسجيل الدخول باستخدام البصمة.',
          isError: true,
        );
        await _loginWithPassword(context, ref, account);
      }
      return;
    }

    if (context.mounted) {
      await _completeLogin(context, ref, result.session!);
    }
  }

  Future<void> _completeLogin(
    BuildContext context,
    WidgetRef ref,
    AuthSession session,
  ) async {
    ref.read(audioServiceProvider).play(SoundEffect.star);

    if (session.isParent) {
      ref.read(activeProfileProvider.notifier).clear();
      ref.read(parentSelectedProfileIdProvider.notifier).state = null;
      context.go('/parent');
      return;
    }

    final profile = session.profile;
    if (profile == null) {
      showAppSnack(
        context,
        'ملف الطالب غير موجود. راجع ولي الأمر.',
        isError: true,
      );
      await ref.read(authProvider.notifier).logout();
      return;
    }
    ref.read(activeProfileProvider.notifier).setProfile(profile);
    await ref.read(settingsProvider.notifier).selectProfile(profile.id);
    if (context.mounted) context.go('/home');
  }
}

class _StudentLoginCard extends StatelessWidget {
  const _StudentLoginCard({required this.account, required this.onTap});

  final AccountSummary account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final avatar = AppAssets
        .profileAvatars[account.avatarIndex % AppAssets.profileAvatars.length];
    return AppCard(
      onTap: onTap,
      semanticLabel: 'تسجيل دخول ${account.displayName}',
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      borderColor: AppColors.skySoft,
      child: SizedBox(
        height: 200, // Fixed height keeps grid tiles uniform
        child: ListView(
          children: [
            Container(
              width: 74,
              height: 74,
              padding: const EdgeInsets.all(7),
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.skyDeep,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              account.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 2),
            Text(
              schoolGradeLabel(account.schoolGrade),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
            if (account.isDevelopment)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.coralSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'حساب تجريبي',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.coralDeep,
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.leafSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'المستوى ${ArabicNumbers.formatInt(account.currentLevel)}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.leafDeep,
                    ),
              ),
            ),
            if (account.needsPassword) ...[
              const SizedBox(height: 6),
              Text(
                'أول دخول: عيّن كلمة مرور',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.coralDeep,
                      fontSize: 11,
                    ),
              ),
            ],
            Consumer(
              builder: (context, ref, child) {
                return FutureBuilder<bool>(
                  future: ref
                      .read(biometricServiceProvider)
                      .isBiometricEnabled(account.id),
                  builder: (context, snapshot) {
                    final biometricEnabled = snapshot.data ?? false;
                    if (!biometricEnabled) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fingerprint_rounded,
                            size: 14,
                            color: AppColors.leaf,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'البصمة مفعلة',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.leaf,
                                      fontSize: 11,
                                    ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentLoginCard extends StatelessWidget {
  const _ParentLoginCard({required this.account, required this.onTap});

  final AccountSummary account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      semanticLabel: 'تسجيل دخول ولي الأمر',
      color: AppColors.leafSoft,
      borderColor: AppColors.leaf.withValues(alpha: 0.25),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.family_restroom_rounded,
              color: AppColors.leafDeep,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ولي الأمر',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  account.needsPassword
                      ? 'أول دخول: عيّن كلمة مرور لحساب ولي الأمر'
                      : 'متابعة الطلاب، النتائج، وإدارة الحسابات',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.leafDeep,
          ),
        ],
      ),
    );
  }
}

class _PasswordLoginDialog extends ConsumerStatefulWidget {
  const _PasswordLoginDialog({required this.account});

  final AccountSummary account;

  @override
  ConsumerState<_PasswordLoginDialog> createState() =>
      _PasswordLoginDialogState();
}

class _PasswordLoginDialogState extends ConsumerState<_PasswordLoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  late bool _setupMode = widget.account.needsPassword;
  bool _obscure = true;
  bool _loading = false;
  String? _error;
  AuthSession? _session;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final password = _passwordController.text;
    final auth = ref.read(authProvider.notifier);
    final result = _setupMode
        ? await auth.setInitialPassword(
            userId: widget.account.id,
            password: password,
          )
        : await auth.login(userId: widget.account.id, password: password);
    if (!mounted) return;
    if (result.session != null) {
      _session = result.session;
      Navigator.of(context).pop(_session);
      return;
    }
    setState(() {
      _loading = false;
      _error = result.failure?.message ??
          (result.requiresSetup
              ? 'يجب تعيين كلمة مرور للحساب أولاً.'
              : 'تعذر تسجيل الدخول.');
      if (result.requiresSetup) _setupMode = true;
      if (result.failure == AuthFailure.passwordAlreadySet) {
        _setupMode = false;
        _error = 'كلمة المرور معيّنة مسبقاً. أدخل كلمة المرور للمتابعة.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isParent = widget.account.isParent;
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isParent ? Icons.family_restroom_rounded : Icons.lock_rounded,
            color: AppColors.leafDeep,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(widget.account.displayName)),
        ],
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _setupMode
                    ? (isParent
                        ? 'أول تشغيل: أنشئ كلمة مرور قوية لحساب ولي الأمر. لا توجد كلمة مرور افتراضية.'
                        : 'أول دخول لهذا الطالب: عيّن كلمة مرور خاصة به.')
                    : 'أدخل كلمة المرور للمتابعة.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
                autofocus: true,
                obscureText: _obscure,
                textInputAction:
                    _setupMode ? TextInputAction.next : TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: _setupMode ? 'كلمة المرور الجديدة' : 'كلمة المرور',
                  prefixIcon: const Icon(Icons.key_rounded),
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'إظهار' : 'إخفاء',
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                  ),
                ),
                validator: (value) {
                  if (!_setupMode) {
                    if (value == null || value.isEmpty) {
                      return 'كلمة المرور مطلوبة.';
                    }
                    return null;
                  }
                  return AccountValidators.password(value);
                },
                onFieldSubmitted: (_) {
                  if (!_setupMode) _submit();
                },
              ),
              if (_setupMode) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _submit,
          icon: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.login_rounded, size: 18),
          label: Text(_setupMode ? 'تعيين ودخول' : 'دخول'),
        ),
      ],
    );
  }
}

class _RemoteParentCard extends StatelessWidget {
  const _RemoteParentCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('/parent-remote/connect'),
      color: AppColors.skySoft,
      borderColor: AppColors.sky.withValues(alpha: 0.2),
      semanticLabel: 'متابعة من هاتف ولي الأمر',
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phonelink_ring_rounded,
              color: AppColors.skyDeep,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'متابعة من هاتف ولي الأمر',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'اتصل بهاتف الأبناء عبر نفس شبكة Wi-Fi لعرض النتائج دون إنترنت.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: AppColors.skyDeep),
        ],
      ),
    );
  }
}

class _BiometricChoiceDialog extends ConsumerWidget {
  const _BiometricChoiceDialog({required this.account});

  final AccountSummary account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricService = ref.read(biometricServiceProvider);
    return FutureBuilder<List<BiometricType>>(
      future: biometricService.getAvailableBiometrics(),
      builder: (context, snapshot) {
        final biometricName = snapshot.hasData && snapshot.data!.isNotEmpty
            ? biometricService.getBiometricDisplayName(snapshot.data!)
            : 'البصمة';

        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.fingerprint_rounded, color: AppColors.leafDeep),
              const SizedBox(width: 8),
              Text(account.displayName),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'كيف تريد تسجيل الدخول؟',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildOption(
                context,
                icon: Icons.fingerprint_rounded,
                title: 'استخدام $biometricName',
                subtitle: 'سريع وآمن',
                color: AppColors.leaf,
                onTap: () => Navigator.of(context).pop(true),
              ),
              const SizedBox(height: 12),
              _buildOption(
                context,
                icon: Icons.password_rounded,
                title: 'إدخال كلمة المرور',
                subtitle: 'الطريقة التقليدية',
                color: AppColors.sky,
                onTap: () => Navigator.of(context).pop(false),
              ),
              const SizedBox(height: 12),
              Text(
                'تم تفعيل $biometricName لهذا الحساب.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded),
        ],
      ),
    );
  }
}

/// Username + password login used by the shared testing students
/// (`student1`…`student9`). Normal accounts can keep using the cards.
class _UsernameLoginDialog extends ConsumerStatefulWidget {
  const _UsernameLoginDialog();

  @override
  ConsumerState<_UsernameLoginDialog> createState() =>
      _UsernameLoginDialogState();
}

class _UsernameLoginDialogState extends ConsumerState<_UsernameLoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref.read(authProvider.notifier).loginWithUsername(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;
    if (result.session != null) {
      Navigator.of(context).pop(result.session);
      return;
    }
    setState(() {
      _loading = false;
      _error = result.failure?.message ?? 'تعذر تسجيل الدخول.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.badge_rounded, color: AppColors.leafDeep),
          const SizedBox(width: 8),
          const Expanded(child: Text('الدخول باسم المستخدم')),
        ],
      ),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                textDirection: TextDirection.ltr,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  labelText: 'اسم المستخدم',
                  hintText: 'student1',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'اسم المستخدم مطلوب.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip:
                        _obscure ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                  ),
                ),
                validator: (value) {
                  if ((value ?? '').isEmpty) {
                    return 'كلمة المرور مطلوبة.';
                  }
                  return null;
                },
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
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('دخول'),
        ),
      ],
    );
  }
}

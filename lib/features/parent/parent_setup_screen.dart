import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/security/parent_gate.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../core/utils/number_parser.dart';
import '../../shared/models/auth_models.dart';
import '../../shared/widgets/app_widgets.dart';

/// First-run provisioning for the parent account.
///
/// The parent account starts without a password, so setting it must never be a
/// one-tap action reachable from the student list. This screen requires an
/// adult-verification challenge before the password fields appear, needs an
/// explicit parent acknowledgement, and refuses to run once a password exists.
class ParentSetupScreen extends ConsumerStatefulWidget {
  const ParentSetupScreen({super.key});

  @override
  ConsumerState<ParentSetupScreen> createState() => _ParentSetupScreenState();
}

class _ParentSetupScreenState extends ConsumerState<ParentSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _gateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  ParentGateChallenge _challenge = ParentGateChallenge.random();
  bool _gatePassed = false;
  bool _acknowledged = false;
  bool _obscure = true;
  bool _saving = false;
  String? _gateError;
  String? _error;

  @override
  void dispose() {
    _gateController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _verifyGate() {
    final parsed = NumberParser.parseInt(_gateController.text);
    if (_challenge.isCorrect(parsed)) {
      setState(() {
        _gatePassed = true;
        _gateError = null;
      });
      _gateController.clear();
      return;
    }
    setState(() {
      _gateController.clear();
      _gateError = 'إجابة غير صحيحة. حلّ العملية الجديدة للمتابعة.';
      _challenge = ParentGateChallenge.random();
    });
  }

  Future<void> _createAccount(AccountSummary parent) async {
    if (_saving || !_acknowledged) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final result = await ref.read(authProvider.notifier).setInitialPassword(
          userId: parent.id,
          password: _passwordController.text,
        );
    if (!mounted) return;
    if (result.isSuccess) {
      context.go('/parent');
      return;
    }
    setState(() {
      _saving = false;
      _error = result.failure?.message ?? 'تعذر إنشاء حساب ولي الأمر.';
    });
    if (result.failure == AuthFailure.passwordAlreadySet) {
      ref.invalidate(accountsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);
    return PlayfulScaffold(
      accent: AppColors.coral,
      appBar: AppBar(
        title: const Text('إعداد حساب ولي الأمر'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: accounts.when(
        loading: () => const LoadingView(message: 'نجهّز حساب ولي الأمر...'),
        error: (error, stackTrace) => ErrorRetryView(
          message: 'تعذر تحميل حسابات الجهاز.',
          onRetry: () => ref.invalidate(accountsProvider),
        ),
        data: (items) {
          final parent = items.where((account) => account.isParent).firstOrNull;
          if (parent == null) {
            return EmptyState(
              title: 'لا يوجد حساب ولي أمر',
              message: 'أعد تشغيل التطبيق لإنشاء حساب ولي الأمر تلقائياً.',
              icon: Icons.admin_panel_settings_outlined,
              action: PressButton(
                onPressed: () => ref.invalidate(accountsProvider),
                child: const Text('إعادة المحاولة'),
              ),
            );
          }
          if (!parent.needsPassword) {
            return _AlreadyConfigured(
              onLogin: () => context.go('/login'),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
            children: [
              if (!_gatePassed) _buildGateCard(context),
              if (_gatePassed) _buildPasswordCard(context, parent),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGateCard(BuildContext context) {
    return AppCard(
      color: AppColors.coralSoft,
      borderColor: AppColors.coral.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_rounded,
                color: AppColors.coralDeep,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تأكيد ولي الأمر',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'إعداد حساب ولي الأمر متاح لولي الأمر فقط. حلّ العملية التالية ثم اختر كلمة مرور لا يعرفها الطفل.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.mutedForeground,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                '${ArabicNumbers.formatInt(_challenge.first)} × '
                '${ArabicNumbers.formatInt(_challenge.second)} = ؟',
                key: const ValueKey('parent-gate-question'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            key: const ValueKey('parent-gate-answer'),
            controller: _gateController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'إجابة العملية',
              prefixIcon: Icon(Icons.calculate_rounded),
            ),
            onSubmitted: (_) => _verifyGate(),
          ),
          if (_gateError != null) ...[
            const SizedBox(height: 10),
            Text(
              _gateError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.coralDeep,
                  ),
            ),
          ],
          const SizedBox(height: 14),
          PressButton(
            onPressed: _verifyGate,
            expanded: true,
            color: AppColors.coralDeep,
            child: const Text('تحقق'),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard(BuildContext context, AccountSummary parent) {
    return AppCard(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'كلمة مرور ولي الأمر',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'هذه الكلمة تحمي لوحة المتابعة والإدارة. لا توجد كلمة مرور افتراضية، ولا يمكن استعادتها من داخل التطبيق.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('parent-setup-password'),
              controller: _passwordController,
              autofocus: true,
              obscureText: _obscure,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                helperText: '٦ أحرف على الأقل',
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
              validator: AccountValidators.password,
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('parent-setup-confirm'),
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
              onFieldSubmitted: (_) => _createAccount(parent),
            ),
            const SizedBox(height: 6),
            CheckboxListTile(
              key: const ValueKey('parent-setup-ack'),
              value: _acknowledged,
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _acknowledged = value ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                'أنا ولي الأمر أو الوصي على هذا الجهاز',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.coralDeep,
                    ),
              ),
            ],
            const SizedBox(height: 10),
            PressButton(
              key: const ValueKey('parent-setup-submit'),
              onPressed: _saving || !_acknowledged
                  ? null
                  : () => _createAccount(parent),
              expanded: true,
              color: AppColors.coralDeep,
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
                  : const Text('إنشاء حساب ولي الأمر'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlreadyConfigured extends StatelessWidget {
  const _AlreadyConfigured({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'حساب ولي الأمر مُعدّ مسبقاً',
      message:
          'تم تعيين كلمة مرور ولي الأمر من قبل. أدخل كلمة المرور من شاشة الدخول، ولا يمكن إعادة تعيينها من هنا.',
      icon: Icons.lock_rounded,
      action:
          PressButton(onPressed: onLogin, child: const Text('تسجيل الدخول')),
    );
  }
}

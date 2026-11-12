import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/widgets/app_widgets.dart';

class ParentGateScreen extends ConsumerStatefulWidget {
  const ParentGateScreen({super.key});

  @override
  ConsumerState<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends ConsumerState<ParentGateScreen> {
  String _pin = '';
  String? _error;

  void _append(String digit) {
    if (_pin.length >= 4) return;
    setState(() {
      _pin = '$_pin$digit';
      _error = null;
    });
  }

  void _backspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _clear() {
    setState(() => _pin = '');
  }

  Future<void> _submit() async {
    if (_pin.length != 4) {
      setState(() => _error = 'أدخل أربعة أرقام.');
      return;
    }
    final settings = ref.read(settingsProvider);
    if (!settings.verifyPin(_pin)) {
      ref.read(audioServiceProvider).play(SoundEffect.wrong);
      setState(() {
        _pin = '';
        _error = 'الرمز غير صحيح. حاول مرة أخرى.';
      });
      return;
    }
    ref.read(audioServiceProvider).play(SoundEffect.star);
    ref.read(parentUnlockedProvider.notifier).state = true;
    if (mounted) context.go('/parent');
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return PlayfulScaffold(
      accent: AppColors.leaf,
      appBar: AppBar(
        title: const Text('منطقة الوالدين'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
        child: Column(
          children: [
            MascotBubble(
              asset: AppAssets.mascotEncouraging,
              message:
                  'هذه المنطقة مخصصة للوالدين لمتابعة التقدم وضبط الإعدادات.',
              onSpeak: () => ref.read(ttsServiceProvider).speak(
                    'هذه المنطقة مخصصة للوالدين لمتابعة التقدم وضبط الإعدادات.',
                  ),
            ),
            const SizedBox(height: 22),
            AppCard(
              child: Column(
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    size: 42,
                    color: AppColors.leafDeep,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'أدخل رمز الوالدين',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final filled = index < _pin.length;
                      return Container(
                        width: 52,
                        height: 58,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: filled ? AppColors.leafSoft : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _error != null
                                ? AppColors.coral
                                : (filled ? AppColors.leaf : AppColors.border),
                            width: filled ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          filled
                              ? ArabicNumbers.toArabicDigits(
                                  _pin[index],
                                )
                              : '•',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: AppColors.leafDeep),
                        ),
                      );
                    }),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.coralDeep,
                          ),
                    ),
                  ],
                  if (settings.usesDefaultPin) ...[
                    const SizedBox(height: 12),
                    Text(
                      'الرمز الافتراضي هو ${ArabicNumbers.toArabicDigits(AppSettings.defaultPin)}. يُنصح بتغييره من لوحة الوالدين.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  NumericKeypad(
                    onDigit: _append,
                    onBackspace: _backspace,
                    onClear: _clear,
                  ),
                  const SizedBox(height: 18),
                  PressButton(
                    onPressed: _submit,
                    expanded: true,
                    color: AppColors.leafDeep,
                    minHeight: 56,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.login_rounded),
                        SizedBox(width: 8),
                        Text('دخول'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

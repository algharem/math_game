import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/services/audio_service.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../../core/services/biometric_service.dart' show BiometricType;

class BiometricSettingsScreen extends ConsumerStatefulWidget {
  const BiometricSettingsScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<BiometricSettingsScreen> createState() =>
      _BiometricSettingsScreenState();
}

class _BiometricSettingsScreenState
    extends ConsumerState<BiometricSettingsScreen> {
  late Future<bool> _biometricAvailableFuture;
  late Future<bool> _biometricEnabledFuture;
  late Future<List<BiometricType>> _availableBiometricsFuture;

  @override
  void initState() {
    super.initState();
    final biometricService = ref.read(biometricServiceProvider);
    _biometricAvailableFuture = biometricService.isBiometricAvailable();
    _biometricEnabledFuture =
        biometricService.isBiometricEnabled(widget.userId);
    _availableBiometricsFuture = biometricService.getAvailableBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return PlayfulScaffold(
      body: FutureBuilder(
        future: Future.wait([
          _biometricAvailableFuture,
          _biometricEnabledFuture,
          _availableBiometricsFuture,
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView(message: 'فحص إعدادات المصادقة...');
          }

          if (snapshot.hasError) {
            return ErrorRetryView(
              message: 'تعذر تحميل إعدادات المصادقة.',
              onRetry: () => setState(() {
                final biometricService = ref.read(biometricServiceProvider);
                _biometricAvailableFuture =
                    biometricService.isBiometricAvailable();
                _biometricEnabledFuture =
                    biometricService.isBiometricEnabled(widget.userId);
                _availableBiometricsFuture =
                    biometricService.getAvailableBiometrics();
              }),
            );
          }

          final data = snapshot.data as List;
          final isBiometricAvailable = data[0] as bool;
          final isBiometricEnabled = data[1] as bool;
          final availableBiometrics = data[2] as List<BiometricType>;

          if (!isBiometricAvailable) {
            return _BiometricNotAvailableView();
          }

          final biometricService = ref.read(biometricServiceProvider);
          final biometricName =
              biometricService.getBiometricDisplayName(availableBiometrics);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            children: [
              MascotBubble(
                asset: 'assets/images/mascot/lion-idle.png',
                message:
                    'يمكنك تفعيل $biometricName لتسجيل الدخول بسرعة دون إدخال كلمة المرور.',
                onSpeak: () => ref.read(ttsServiceProvider).speak(
                      'يمكنك تفعيل $biometricName لتسجيل الدخول بسرعة دون إدخال كلمة المرور.',
                    ),
              ),
              const SizedBox(height: 22),
              Text(
                'إعدادات $biometricName',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.fingerprint_rounded,
                          color: AppColors.leafDeep,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            biometricName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Switch(
                          value: isBiometricEnabled,
                          onChanged: (value) async {
                            ref
                                .read(audioServiceProvider)
                                .play(SoundEffect.tap);
                            await biometricService.setBiometricEnabled(
                              widget.userId,
                              value,
                            );
                            final currentContext = context;
                            if (value) {
                              // Test biometric authentication when enabling
                              final authenticated =
                                  await biometricService.authenticate(
                                userId: widget.userId,
                                localizedReason:
                                    'تفعيل $biometricName - يرجى المصادقة',
                              );
                              if (!authenticated) {
                                // If authentication fails, disable biometric
                                await biometricService.setBiometricEnabled(
                                  widget.userId,
                                  false,
                                );
                                if (mounted && currentContext.mounted) {
                                  showAppSnack(
                                    currentContext,
                                    'تعذر تفعيل $biometricName. حاول مرة أخرى.',
                                    isError: true,
                                  );
                                }
                              } else {
                                if (mounted && currentContext.mounted) {
                                  showAppSnack(
                                    currentContext,
                                    'تم تفعيل $biometricName بنجاح!',
                                  );
                                }
                              }
                            } else {
                              if (mounted && currentContext.mounted) {
                                showAppSnack(
                                  currentContext,
                                  'تم إلغاء تفعيل $biometricName.',
                                );
                              }
                            }
                            setState(() {
                              _biometricEnabledFuture = biometricService
                                  .isBiometricEnabled(widget.userId);
                            });
                          },
                          activeColor: AppColors.leaf,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isBiometricEnabled
                          ? 'مفعلة - يمكنك تسجيل الدخول باستخدام $biometricName'
                          : 'معطلة - يجب إدخال كلمة المرور عند كل تسجيل دخول',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات $biometricName',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildBiometricInfoItem(
                      'النوع',
                      availableBiometrics.isNotEmpty
                          ? biometricName
                          : 'غير معروف',
                    ),
                    _buildBiometricInfoItem(
                      'الحالة',
                      isBiometricEnabled ? 'مفعلة' : 'معطلة',
                    ),
                    _buildBiometricInfoItem(
                      'الأمان',
                      'آمنة ومشفرة على الجهاز فقط',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (isBiometricEnabled) ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إدارة $biometricName',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      PressButton(
                        onPressed: () async {
                          ref
                              .read(audioServiceProvider)
                              .play(SoundEffect.tap);
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('إزالة $biometricName'),
                              content: Text(
                                'سيتم حذف إعدادات $biometricName لهذا الحساب. يجب إعادة تفعيلها من البداية.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('إلغاء'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.coral,
                                  ),
                                  child: const Text('حذف'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await biometricService.clearBiometricData(
                              widget.userId,
                            );
                            final currentContext = context;
                            setState(() {
                              _biometricEnabledFuture = biometricService
                                  .isBiometricEnabled(widget.userId);
                            });
                            if (mounted && currentContext.mounted) {
                              showAppSnack(
                                currentContext,
                                'تم حذف إعدادات $biometricName.',
                              );
                            }
                          }
                        },
                        color: AppColors.coral,
                        foregroundColor: Colors.white,
                        child: const Text('إزالة إعدادات البصمة'),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                'ملاحظات هامة',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              AppCard(
                color: AppColors.skySoft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNoteItem(
                      '• $biometricName مخزنة على الجهاز فقط ولا يتم إرسالها لأي خادم.',
                    ),
                    _buildNoteItem(
                      '• يمكن إعادة تفعيل $biometricName في أي وقت من إعدادات الحساب.',
                    ),
                    _buildNoteItem(
                      '• في حالة فقدان الجهاز، يمكن تسجيل الدخول بكلمة المرور الأصلية.',
                    ),
                    _buildNoteItem(
                      '• يجب تفعيل قفل الشاشة على الجهاز لاستخدام $biometricName.',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBiometricInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.mutedForeground,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.mutedForeground),
      ),
    );
  }
}

class _BiometricNotAvailableView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      children: [
        MascotBubble(
          asset: 'assets/images/mascot/lion-encouraging.png',
          message:
              'جهازك لا يدعم المصادقة الحيوية (البصمة/الوجه). يمكنك استخدام كلمة المرور كالعادة.',
          onSpeak: null,
        ),
        const SizedBox(height: 22),
        Text(
          'المصادقة الحيوية غير متاحة',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              const Icon(
                Icons.device_unknown_rounded,
                size: 64,
                color: AppColors.mutedForeground,
              ),
              const SizedBox(height: 16),
              Text(
                'جهازك لا يدعم المصادقة الحيوية',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'تتطلب المصادقة الحيوية (البصمة/الوجه) جهازاً يدعم مستشعرات الأمان الحيوي.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'يمكنك الاستمرار باستخدام:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.password_rounded, color: AppColors.leaf),
                  const SizedBox(width: 8),
                  Text(
                    'كلمة المرور',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'لماذا لا تعمل المصادقة الحيوية؟',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        AppCard(
          color: AppColors.skySoft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReasonItem(
                '• الجهاز لا يحتوي على مستشعر بصمة أو كاميرا للتعرف على الوجه.',
              ),
              _buildReasonItem(
                '• قفل الشاشة غير مفعل على الجهاز.',
              ),
              _buildReasonItem(
                '• ليس لديك بصمة أو وجه مسجل في إعدادات الجهاز.',
              ),
              _buildReasonItem(
                '• إعدادات أمان الجهاز تمنع استخدام المصادقة الحيوية.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReasonItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.mutedForeground),
      ),
    );
  }
}
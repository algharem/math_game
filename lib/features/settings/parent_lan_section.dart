import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/network/parent_lan_controller.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/widgets/app_widgets.dart';

class ParentLanSection extends ConsumerStatefulWidget {
  const ParentLanSection({super.key});

  @override
  ConsumerState<ParentLanSection> createState() => _ParentLanSectionState();
}

class _ParentLanSectionState extends ConsumerState<ParentLanSection> {
  late final TextEditingController _portController;
  final FocusNode _portFocus = FocusNode();
  String? _syncedPort;

  @override
  void initState() {
    super.initState();
    final port = ref.read(parentLanControllerProvider).port;
    _portController = TextEditingController(text: '$port');
    _syncedPort = '$port';
  }

  @override
  void dispose() {
    _portController.dispose();
    _portFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(parentLanControllerProvider);
    final portText = '${controller.port}';
    if (!_portFocus.hasFocus && _syncedPort != portText) {
      _portController.text = portText;
      _syncedPort = portText;
    }
    final connection = controller.connectionInfo;
    final lastSeen = controller.lastParentSeen;
    final connected = lastSeen != null &&
        DateTime.now().difference(lastSeen) <= const Duration(seconds: 45);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: controller.isRunning
                      ? AppColors.leafSoft
                      : AppColors.skySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.isRunning ? Icons.wifi_tethering : Icons.wifi_off,
                  color: controller.isRunning
                      ? AppColors.leafDeep
                      : AppColors.skyDeep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'خادم هاتف الأبناء',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      controller.isRunning
                          ? 'يعمل داخل شبكة Wi-Fi المحلية'
                          : 'متوقف',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: controller.isRunning
                                ? AppColors.leafDeep
                                : AppColors.mutedForeground,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoRow(
            label: 'عنوان IP',
            value: controller.ipAddress ?? 'غير متصل بشبكة Wi-Fi',
            icon: Icons.router_rounded,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'المنفذ',
            value: ArabicNumbers.formatInt(controller.port),
            icon: Icons.numbers_rounded,
          ),
          if (connection != null) ...[
            const SizedBox(height: 8),
            _InfoRow(
              label: 'عنوان الاتصال',
              value: connection.baseUrl,
              icon: Icons.link_rounded,
              selectable: true,
              trailing: IconButton(
                tooltip: 'نسخ',
                onPressed: () => _copy(context, connection.baseUrl),
                icon: const Icon(Icons.copy_rounded, size: 18),
              ),
            ),
          ],
          const SizedBox(height: 8),
          _InfoRow(
            label: 'حالة ولي الأمر',
            value: connected
                ? 'متصل من هاتف آخر'
                : lastSeen == null
                    ? 'لم يتصل بعد'
                    : 'آخر اتصال: ${_formatTime(lastSeen)}',
            icon: Icons.family_restroom_rounded,
            valueColor:
                connected ? AppColors.leafDeep : AppColors.mutedForeground,
          ),
          if (controller.parentNeedsPassword) ...[
            const SizedBox(height: 10),
            const _WarningNote(
              text:
                  'عيّن كلمة مرور لحساب ولي الأمر أولاً قبل السماح بالاتصال من هاتف آخر.',
            ),
          ],
          if (controller.error != null) ...[
            const SizedBox(height: 10),
            _WarningNote(text: controller.error!, isError: true),
          ],
          const SizedBox(height: 14),
          if (!controller.isRunning)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _portController,
                    focusNode: _portFocus,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'المنفذ',
                      hintText: '8080',
                      prefixIcon: Icon(Icons.settings_ethernet_rounded),
                    ),
                    onChanged: (_) => _syncedPort = null,
                  ),
                ),
                const SizedBox(width: 10),
                PressButton(
                  onPressed:
                      controller.isStarting ? null : () => _start(controller),
                  minHeight: 48,
                  child: controller.isStarting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('تشغيل'),
                ),
              ],
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PressButton(
                  onPressed:
                      controller.isStopping ? null : () => controller.stop(),
                  color: AppColors.coralSoft,
                  foregroundColor: AppColors.coralDeep,
                  minHeight: 44,
                  child: const Text('إيقاف الخادم'),
                ),
                PressButton(
                  onPressed: () => controller.refreshNetwork(),
                  color: AppColors.skySoft,
                  foregroundColor: AppColors.skyDeep,
                  minHeight: 44,
                  child: const Text('تحديث العنوان'),
                ),
              ],
            ),
          if (connection != null) ...[
            const SizedBox(height: 16),
            Text(
              'رمز QR لربط هاتف ولي الأمر',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: QrImageView(
                  data: connection.qrPayload,
                  version: QrVersions.auto,
                  size: 220,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'يعمل فقط عندما يكون الهاتفان على نفس شبكة Wi-Fi. إذا أُغلق التطبيق أو تغيّر عنوان IP، أعد تشغيل الخادم وامسح الرمز من جديد.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _start(ParentLanController controller) async {
    final port = int.tryParse(_portController.text.trim());
    if (port == null || port < 1024 || port > 65535) {
      showAppSnack(
        context,
        'أدخل منفذاً صالحاً بين ${ArabicNumbers.formatInt(1024)} و${ArabicNumbers.formatInt(65535)}.',
        isError: true,
      );
      return;
    }
    try {
      await controller.setPort(port);
      await controller.start();
      if (mounted) showAppSnack(context, 'تم تشغيل خادم هاتف الأبناء.');
    } catch (_) {
      if (mounted) {
        showAppSnack(
          context,
          controller.error ?? 'تعذر تشغيل الخادم المحلي.',
          isError: true,
        );
      }
    }
  }

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) {
      showAppSnack(context, 'تم نسخ عنوان الاتصال.');
    }
  }

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return ArabicNumbers.toArabicDigits('$hour:$minute');
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.selectable = false,
    this.valueColor,
    this.trailing,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool selectable;
  final Color? valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: valueColor ?? AppColors.ink,
          fontWeight: FontWeight.w700,
        );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.skyDeep),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
              ),
              selectable
                  ? SelectableText(value, style: valueStyle)
                  : Text(value, style: valueStyle),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.text, this.isError = false});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.coralSoft : AppColors.sunSoft;
    final icon = isError ? Icons.error_outline_rounded : Icons.info_outline;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

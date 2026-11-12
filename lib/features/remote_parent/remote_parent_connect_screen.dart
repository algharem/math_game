import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/network/lan_connection.dart';
import '../../core/network/parent_lan_client.dart';
import '../../shared/widgets/app_widgets.dart';

class RemoteParentConnectScreen extends ConsumerStatefulWidget {
  const RemoteParentConnectScreen({super.key});

  @override
  ConsumerState<RemoteParentConnectScreen> createState() =>
      _RemoteParentConnectScreenState();
}

class _RemoteParentConnectScreenState
    extends ConsumerState<RemoteParentConnectScreen> {
  final _urlController = TextEditingController();
  bool _processing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final saved = ref.read(settingsServiceProvider).remoteParentUrl;
    if (saved != null) _urlController.text = saved;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlayfulScaffold(
      accent: AppColors.sky,
      appBar: AppBar(
        title: const Text('الاتصال بهاتف الأبناء'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'امسح رمز QR',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'على هاتف الأبناء افتح إعدادات ولي الأمر > الاتصال بهاتف ولي الأمر، ثم شغّل الخادم وامسح الرمز الظاهر.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: MobileScanner(
                      onDetect: _onDetect,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أو أدخل عنوان الاتصال يدوياً',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: 'عنوان الاتصال',
                    hintText: 'http://192.168.1.10:8080',
                    prefixIcon: Icon(Icons.link_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                PressButton(
                  onPressed: _processing ? null : _connectManual,
                  expanded: true,
                  child: _processing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('اتصال'),
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            AppCard(
              color: AppColors.coralSoft,
              borderColor: AppColors.coral.withValues(alpha: 0.2),
              child: Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.coralDeep,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    final barcode = capture.barcodes.isEmpty ? null : capture.barcodes.first;
    final raw = barcode?.rawValue;
    if (raw == null || raw.trim().isEmpty) return;
    final connection = LanConnectionInfo.parse(raw);
    if (connection == null) return;
    await _connect(connection);
  }

  Future<void> _connectManual() async {
    final connection = LanConnectionInfo.parse(_urlController.text);
    if (connection == null) {
      setState(() {
        _error = 'أدخل عنواناً صالحاً مثل http://192.168.1.10:8080';
      });
      return;
    }
    await _connect(connection);
  }

  Future<void> _connect(LanConnectionInfo connection) async {
    if (_processing) return;
    setState(() {
      _processing = true;
      _error = null;
    });
    try {
      final health = await ParentLanClient.probe(connection.baseUrl);
      final enriched = LanConnectionInfo(
        baseUrl: connection.baseUrl,
        deviceName: health['deviceName']?.toString() ?? connection.deviceName,
        loginName: health['loginName']?.toString() ?? connection.loginName,
      );
      await ref.read(settingsServiceProvider).saveRemoteParentConnection(
            url: enriched.baseUrl,
            loginName: enriched.loginName,
            deviceName: enriched.deviceName,
          );
      if (!mounted) return;
      context.go('/parent-remote/login', extra: enriched);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is LanApiException
            ? error.message
            : 'تعذر الاتصال بهاتف الأبناء. تأكد من الشبكة والعنوان.';
      });
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }
}

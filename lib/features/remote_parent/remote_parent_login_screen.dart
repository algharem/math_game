import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/network/lan_connection.dart';
import '../../core/network/parent_lan_client.dart';
import '../../shared/widgets/app_widgets.dart';

class RemoteParentLoginScreen extends ConsumerStatefulWidget {
  const RemoteParentLoginScreen({super.key, required this.connection});

  final LanConnectionInfo connection;

  @override
  ConsumerState<RemoteParentLoginScreen> createState() =>
      _RemoteParentLoginScreenState();
}

class _RemoteParentLoginScreenState
    extends ConsumerState<RemoteParentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.connection.loginName ?? 'ولي الأمر',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlayfulScaffold(
      accent: AppColors.sky,
      appBar: AppBar(
        title: const Text('تسجيل دخول ولي الأمر'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.go('/parent-remote/connect'),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          AppCard(
            color: AppColors.skySoft,
            borderColor: AppColors.sky.withValues(alpha: 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.connection.deviceName ?? 'هاتف الأبناء',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.connection.baseUrl,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'استخدم حساب ولي الأمر الموجود على هاتف الأبناء.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'اسم المستخدم',
                      prefixIcon: Icon(Icons.person_rounded),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'أدخل اسم المستخدم.'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_rounded),
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
                    validator: (value) => value == null || value.isEmpty
                        ? 'أدخل كلمة المرور.'
                        : null,
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
                  const SizedBox(height: 16),
                  PressButton(
                    onPressed: _loading ? null : _login,
                    expanded: true,
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('دخول'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final client = ParentLanClient(widget.connection);
    try {
      await client.authenticate(
        _usernameController.text,
        _passwordController.text,
      );
      final session = RemoteParentSession(widget.connection, client);
      await ref.read(settingsServiceProvider).saveRemoteParentConnection(
            url: widget.connection.baseUrl,
            loginName: widget.connection.loginName ?? _usernameController.text,
            deviceName: widget.connection.deviceName,
            lastSync: DateTime.now(),
          );
      if (!mounted) return;
      context.go('/parent-remote/dashboard', extra: session);
    } catch (error) {
      client.close();
      if (!mounted) return;
      setState(() {
        _error = error is LanApiException
            ? error.message
            : 'تعذر تسجيل الدخول. تأكد من البيانات والاتصال.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

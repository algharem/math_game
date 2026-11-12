class LanConnectionInfo {
  LanConnectionInfo({
    required String baseUrl,
    this.deviceName,
    this.loginName,
  }) : baseUrl = _normalizeBaseUrl(baseUrl);

  final String baseUrl;
  final String? deviceName;
  final String? loginName;

  String get qrPayload {
    final parameters = <String, String>{'url': baseUrl};
    if (deviceName != null && deviceName!.trim().isNotEmpty) {
      parameters['name'] = deviceName!.trim();
    }
    if (loginName != null && loginName!.trim().isNotEmpty) {
      parameters['login'] = loginName!.trim();
    }
    return Uri(
      scheme: 'mathheroes',
      host: 'parent-connect',
      queryParameters: parameters,
    ).toString();
  }

  static LanConnectionInfo? parse(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null) return null;

    if (uri.scheme == 'mathheroes' && uri.host == 'parent-connect') {
      final baseUrl = uri.queryParameters['url'];
      if (baseUrl == null) return null;
      return tryCreate(
        baseUrl,
        deviceName: uri.queryParameters['name'],
        loginName: uri.queryParameters['login'],
      );
    }

    return tryCreate(value);
  }

  static LanConnectionInfo? tryCreate(
    String? value, {
    String? deviceName,
    String? loginName,
  }) {
    final normalized = _normalizeBaseUrl(value ?? '');
    final uri = Uri.tryParse(normalized);
    if (uri == null) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;
    if (uri.host.isEmpty) return null;
    if (uri.port < 1 || uri.port > 65535) return null;
    if (uri.path.isNotEmpty && uri.path != '/') return null;
    if (uri.hasQuery || uri.hasFragment) return null;
    return LanConnectionInfo(
      baseUrl: normalized,
      deviceName: _clean(deviceName),
      loginName: _clean(loginName),
    );
  }

  static String _normalizeBaseUrl(String value) {
    var normalized = value.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

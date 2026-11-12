import 'dart:io';

class LanNetwork {
  LanNetwork._();

  static Future<String?> preferredLocalIPv4() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      final candidates = <_Candidate>[];
      for (final interface in interfaces) {
        for (final address in interface.addresses) {
          if (!_isPrivateIpv4(address)) continue;
          final name = interface.name.toLowerCase();
          final score = name.contains('wlan') || name.contains('wifi')
              ? 0
              : name.contains('eth')
                  ? 1
                  : 2;
          candidates.add(_Candidate(address.address, score));
        }
      }
      if (candidates.isEmpty) return null;
      candidates.sort((a, b) => a.score.compareTo(b.score));
      return candidates.first.address;
    } catch (_) {
      return null;
    }
  }

  static bool _isPrivateIpv4(InternetAddress address) {
    final bytes = address.rawAddress;
    if (bytes.length != 4) return false;
    if (bytes[0] == 10) return true;
    if (bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) return true;
    if (bytes[0] == 192 && bytes[1] == 168) return true;
    if (bytes[0] == 169 && bytes[1] == 254) return true;
    return false;
  }
}

class _Candidate {
  const _Candidate(this.address, this.score);

  final String address;
  final int score;
}

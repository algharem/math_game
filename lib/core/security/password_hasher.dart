import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class PasswordHashMaterial {
  const PasswordHashMaterial({
    required this.salt,
    required this.iterations,
    required this.key,
  });

  final Uint8List salt;
  final int iterations;
  final Uint8List key;
}

class PasswordHasher {
  PasswordHasher._();

  static const algorithm = 'pbkdf2_sha256';
  static const defaultIterations = 120000;
  static const defaultKeyLength = 32;
  static const _saltLength = 16;

  static String hash(String password) {
    if (password.isEmpty) {
      throw ArgumentError.value(password, 'password', 'كلمة المرور مطلوبة');
    }
    final random = Random.secure();
    final salt = Uint8List.fromList(
      List<int>.generate(_saltLength, (_) => random.nextInt(256)),
    );
    final derived = deriveKey(
      password,
      salt: salt,
      iterations: defaultIterations,
      keyLength: defaultKeyLength,
    );
    return '$algorithm\$$defaultIterations\$${base64Encode(salt)}\$${base64Encode(derived)}';
  }

  static bool verify(String password, String encoded) {
    if (password.isEmpty || encoded.isEmpty) return false;
    final material = materialFrom(encoded);
    if (material == null) return false;
    final actual = deriveKey(
      password,
      salt: material.salt,
      iterations: material.iterations,
      keyLength: material.key.length,
    );
    return constantTimeEquals(actual, material.key);
  }

  static PasswordHashMaterial? materialFrom(String encoded) {
    if (encoded.isEmpty) return null;
    final parts = encoded.split(r'$');
    if (parts.length != 4 || parts[0] != algorithm) return null;
    final iterations = int.tryParse(parts[1]);
    if (iterations == null || iterations <= 0) return null;
    try {
      final salt = base64Decode(parts[2]);
      final key = base64Decode(parts[3]);
      if (salt.isEmpty || key.isEmpty) return null;
      return PasswordHashMaterial(
        salt: Uint8List.fromList(salt),
        iterations: iterations,
        key: Uint8List.fromList(key),
      );
    } on FormatException {
      return null;
    }
  }

  static Uint8List deriveKey(
    String password, {
    required List<int> salt,
    required int iterations,
    required int keyLength,
  }) {
    final hmac = Hmac(sha256, utf8.encode(password));
    const digestLength = 32;
    final blocks = (keyLength / digestLength).ceil();
    final output = BytesBuilder(copy: false);

    for (var block = 1; block <= blocks; block++) {
      final blockBytes = ByteData(4)..setUint32(0, block, Endian.big);
      var u = Uint8List.fromList(
        hmac.convert([...salt, ...blockBytes.buffer.asUint8List()]).bytes,
      );
      final t = Uint8List.fromList(u);

      for (var iteration = 1; iteration < iterations; iteration++) {
        u = Uint8List.fromList(hmac.convert(u).bytes);
        for (var index = 0; index < t.length; index++) {
          t[index] ^= u[index];
        }
      }
      output.add(t);
    }

    return Uint8List.sublistView(output.toBytes(), 0, keyLength);
  }

  static String proofForNonce({
    required List<int> key,
    required String nonce,
  }) {
    final nonceBytes = base64Url.decode(base64Url.normalize(nonce));
    final digest = Hmac(sha256, key).convert(nonceBytes);
    return base64Encode(digest.bytes);
  }

  static bool verifyProof({
    required List<int> key,
    required String nonce,
    required String proof,
  }) {
    try {
      final expected = base64Decode(
        proofForNonce(key: key, nonce: nonce),
      );
      final actual = base64Decode(proof);
      return constantTimeEquals(expected, actual);
    } on FormatException {
      return false;
    }
  }

  static bool constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var index = 0; index < a.length; index++) {
      result |= a[index] ^ b[index];
    }
    return result == 0;
  }
}

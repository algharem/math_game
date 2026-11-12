import 'package:flutter_test/flutter_test.dart';
import 'package:math_heroes/core/security/password_hasher.dart';

void main() {
  group('PasswordHasher', () {
    test('hashes and verifies a password', () {
      final encoded = PasswordHasher.hash('secret123');

      expect(encoded.split(r'$'), hasLength(4));
      expect(encoded, startsWith(r'pbkdf2_sha256$120000$'));
      expect(PasswordHasher.verify('secret123', encoded), isTrue);
    });

    test('rejects the wrong password', () {
      final encoded = PasswordHasher.hash('secret123');

      expect(PasswordHasher.verify('secret124', encoded), isFalse);
      expect(PasswordHasher.verify('', encoded), isFalse);
    });

    test('uses a unique salt for every hash', () {
      final first = PasswordHasher.hash('same-password');
      final second = PasswordHasher.hash('same-password');

      expect(first, isNot(second));
      expect(PasswordHasher.verify('same-password', first), isTrue);
      expect(PasswordHasher.verify('same-password', second), isTrue);
    });

    test('rejects malformed or modified hashes', () {
      final encoded = PasswordHasher.hash('secret123');
      final parts = encoded.split(r'$');
      final changed = [
        parts[0],
        parts[1],
        parts[2],
        'A${parts[3].substring(1)}',
      ].join(r'$');

      expect(PasswordHasher.verify('secret123', ''), isFalse);
      expect(PasswordHasher.verify('secret123', 'not-a-hash'), isFalse);
      expect(PasswordHasher.verify('secret123', 'pbkdf2_sha256\$nope\$a\$b'),
          isFalse);
      expect(PasswordHasher.verify('secret123', changed), isFalse);
    });

    test('creates and verifies a login proof for a nonce', () {
      final encoded = PasswordHasher.hash('secret123');
      final material = PasswordHasher.materialFrom(encoded);
      const nonce = 'bm9uY2UtdGVzdA=='; // base64("nonce-test")

      expect(material, isNotNull);
      final proof = PasswordHasher.proofForNonce(
        key: material!.key,
        nonce: nonce,
      );
      expect(
        PasswordHasher.verifyProof(
          key: material.key,
          nonce: nonce,
          proof: proof,
        ),
        isTrue,
      );
      expect(
        PasswordHasher.verifyProof(
          key: material.key,
          nonce: nonce,
          proof: 'bad-proof',
        ),
        isFalse,
      );
    });
  });
}

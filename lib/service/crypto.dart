// import './http.dart' show get;
// import 'package:encrypt/encrypt.dart';

// Future<Map<String, dynamic>> getEncryptPassword(String password) async {
//   final resp = await get('auth/public-key');
//   if (resp['error'] == true) {
//     return resp;
//   }
//   final encryptedPwd = encryptWithPublicKey(resp['publicKey'], password);
//   return {'error': false, 'password': encryptedPwd};
// }

// String encryptWithPublicKey(String publicKeyPEM, String plainText) {
//   final parser = RSAKeyParser();
//   dynamic publicKey = parser.parse(publicKeyPEM);
//   final encrypter =
//       Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP));
//   final encrypted = encrypter.encrypt(plainText);
//   return encrypted.base64;
// }
// import 'dart:convert';
// import 'package:pointycastle/asymmetric/api.dart' show RSAPublicKey;
// import './http.dart' show get;
// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:crypto/crypto.dart';

// Future<Map<String, dynamic>> getEncryptPassword(String password) async {
//   final resp = await get('auth/public-key');
//   if (resp['error'] == true) {
//     return resp;
//   }
//   final encryptedPwd = encryptWithPublicKey(resp['publicKey'], password);
//   return {
//     'error': false,
//     'password': encryptedPwd,
//     'publicKeyFingerprint': _getKeyFingerprint(resp['publicKey']),
//   };
// }

// String encryptWithPublicKey(String publicKeyPEM, String plainText) {
//   if (publicKeyPEM.isEmpty) throw ArgumentError('Public key is empty');
//   if (plainText.isEmpty) throw ArgumentError('Password is empty');
//   final parser = encrypt.RSAKeyParser();
//   final publicKey = parser.parse(publicKeyPEM) as RSAPublicKey;
//   final encrypter = encrypt.Encrypter(encrypt.RSA(
//     publicKey: publicKey,
//     encoding: encrypt.RSAEncoding.OAEP,
//     digest: encrypt.RSADigest.SHA256,
//   ));
//   final encrypted = encrypter.encrypt(plainText);
//   return encrypted.base64;
// }

// String _getKeyFingerprint(String publicKeyPEM) {
//   final cleanKey = publicKeyPEM
//       .replaceAll('-----BEGIN PUBLIC KEY-----', '')
//       .replaceAll('-----END PUBLIC KEY-----', '')
//       .replaceAll(RegExp(r'\s'), '');
//   final bytes = base64.decode(cleanKey);
//   final hash = sha256.convert(bytes).bytes;
//   return base64.encode(hash.sublist(0, 8));
// }
import 'package:pointycastle/asymmetric/api.dart' show RSAPublicKey;
import './http.dart' show get;
import 'package:encrypt/encrypt.dart' as encrypt;

Future<Map<String, dynamic>> getEncryptPassword(String password) async {
  final resp = await get('auth/public-key');
  if (resp['error'] == true) {
    return resp;
  }
  final encryptedPwd = encryptWithPublicKey(resp['publicKey'], password);
  return {
    'error': false,
    'password': encryptedPwd,
  };
}

String encryptWithPublicKey(String publicKeyPEM, String plainText) {
  if (publicKeyPEM.isEmpty) throw ArgumentError('Public key is empty');
  if (plainText.isEmpty) throw ArgumentError('Password is empty');

  final parser = encrypt.RSAKeyParser();
  final publicKey = parser.parse(publicKeyPEM) as RSAPublicKey;

  final encrypter = encrypt.Encrypter(encrypt.RSA(
    publicKey: publicKey,
    encoding: encrypt.RSAEncoding.OAEP,
    digest: encrypt.RSADigest.SHA256,
  ));

  final encrypted = encrypter.encrypt(plainText);
  return encrypted.base64;
}

import './http.dart' show get;
import 'package:encrypt/encrypt.dart';

Future<Map<String, dynamic>> getEncryptPassword(String password) async {
  final resp = await get('auth/public-key');
  if (resp['error'] == true) {
    return resp;
  }
  final encryptedPwd = encryptWithPublicKey(resp['publicKey'], password);
  return {'error': false, 'password': encryptedPwd};
}

String encryptWithPublicKey(String publicKeyPEM, String plainText) {
  final parser = RSAKeyParser();
  dynamic publicKey = parser.parse(publicKeyPEM);
  final encrypter =
      Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP));
  final encrypted = encrypter.encrypt(plainText);
  return encrypted.base64;
}

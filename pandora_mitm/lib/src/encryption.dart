import 'dart:convert';
import 'dart:typed_data';

import 'package:iapetus/iapetus.dart';
import 'package:iapetus/iapetus_data.dart';

class DecryptedJson {
  final Map<String, dynamic> json;
  final String? key;

  const DecryptedJson(this.json, [this.key]);

  bool get wasEncrypted => key != null;
}

/// An object that lazily caches encryption configurations, automatically
/// selecting the right one to use based on the input data.
class EncryptionManager {
  final Map<String, Converter<List<int>, String>> _encrypters = {};
  final Map<String, Converter<String, Uint8List>> _decrypters = {};
  Partner? _lastDetectedPartner;

  DecryptedJson? decrypt(String data, {required bool request}) {
    try {
      return DecryptedJson(jsonDecode(data) as Map<String, dynamic>);
    } on FormatException {
      // The data is likely encrypted.
    }

    DecryptedJson _decryptWithPartner(Partner partner) {
      final Converter<String, Uint8List> decrypter;
      final key =
          request ? partner.requestEncryptKey : partner.responseEncryptKey;
      decrypter = _decrypters[key] ??= buildPandoraDecrypter(key);
      return DecryptedJson(
        jsonDecode(pandoraDecrypt(data, decrypter)) as Map<String, dynamic>,
        key,
      );
    }

    if (_lastDetectedPartner != null) {
      try {
        _decryptWithPartner(_lastDetectedPartner!);
      } on FormatException {
        // The data is likely encrypted by a new partner.
      }
    }

    for (final partner in partners) {
      try {
        final decryptedJson = _decryptWithPartner(partner);
        _lastDetectedPartner = partner;
        return decryptedJson;
      } on FormatException {
        continue;
      }
    }

    return null;
  }

  String encrypt(DecryptedJson decryptedJson) {
    final key = decryptedJson.key;
    final data = jsonEncode(decryptedJson.json);

    return key == null
        ? data
        : pandoraEncrypt(data, _encrypters[key] ??= buildPandoraEncrypter(key));
  }
}

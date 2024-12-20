

import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:payu/main.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
//Remove this plugin when you implement the salt at your server..
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashService {
static const Uuid _uuid = Uuid();
static String UuidtxnId ='';
static String getUuid(){
 List op=[];
  op.sort();

    UuidtxnId = _uuid.v7obj().toString();
return UuidtxnId;
 }
//Find the test credentials from dev guide: https://devguide.payu.in/flutter-sdk-integration/getting-started-flutter-sdk/mobile-sdk-test-environment/ 
//Keep the hash in backend for Security reasons. 
static const livemerchantSalt = "";// Add you Salt here. 
static const testemerchantSalt = "mMprU4id";// Add you Salt here. 
static const merchantSecretKey = "";// Add Merchant Secrete Key - Optional

  static Map generateHash(Map response) {

    
    log('print------------PESU---------- :sdk hash: $response');
    var hashName = response[PayUHashConstantsKeys.hashName];
    var hashStringWithoutSalt = response[PayUHashConstantsKeys.hashString];
    var hashType = response[PayUHashConstantsKeys.hashType];
    var postSalt = response[PayUHashConstantsKeys.postSalt];

    var hash = "";

    if (hashType == PayUHashConstantsKeys.hashVersionV2) {
      hash = getHmacSHA256Hash(hashStringWithoutSalt, testemerchantSalt);
    } else if (hashName == PayUHashConstantsKeys.mcpLookup) {
      hash = getHmacSHA1Hash(hashStringWithoutSalt, merchantSecretKey);
    } else {
    log('print------------PESU---------- :hasnname: $hashName');
    log('print------------PESU---------- :hashStringWithoutSalt: $hashStringWithoutSalt');
      var hashDataWithSalt = "$hashStringWithoutSalt$testemerchantSalt";
      if (postSalt != null) {
        hashDataWithSalt = hashDataWithSalt + postSalt;
      }
    log('print------------PESU---------- :haswithsalt: $hashDataWithSalt');
      hash = getSHA512Hash(hashDataWithSalt);
      log('print------------PESU---------- :getSHA512Hash: ${hash.toString()}');
    }
    //Don't use this method, get the hash from your backend.
    var finalHash = {hashName: hash};
     log('print------------PESU---------- :final hash: ${finalHash.toString()}');
    return finalHash;
  }

  //Don't use this method get the hash from your backend.
  static String getSHA512Hash(String hashData) {
    var bytes = utf8.encode(hashData); // data being hashed
    var hash = sha512.convert(bytes);
    return hash.toString();
  }

 
  //Don't use this method get the hash from your backend.
  static String getHmacSHA256Hash(String hashData, String salt) {
    var key = utf8.encode(salt);
    var bytes = utf8.encode(hashData);
    final hmacSha256 = Hmac(sha256, key)
      .convert(bytes)
      .bytes;
    final hmacBase64 = base64Encode(hmacSha256);
    return hmacBase64;
  }

  static String getHmacSHA1Hash(String hashData, String salt) {
    var key = utf8.encode(salt);
    var bytes = utf8.encode(hashData);
    var hmacSha1 = Hmac(sha1, key); // HMAC-SHA1
    var hash = hmacSha1.convert(bytes);
    return hash.toString();
  }
}

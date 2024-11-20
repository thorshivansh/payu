// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:http_requests/http_requests.dart';
import 'package:http/http.dart' as https;
import 'package:payu/HashService.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'dart:convert';
//Dont Use this file and do the hash calculation in backend.
// import 'package:payu_checkoutpro_flutter_example/HashService.dart';
// import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
// import 'package:uuid/rng.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements PayUCheckoutProProtocol {
  String generatedHash = '';
  // var payuTxID = uuid.v7obj().toString();
  late PayUCheckoutProFlutter _checkoutPro;

  @override
  generateHash(Map response) async {
    // Backend will generate the hash which you need to pass to SDK
    // hashResponse: is the response which you get from your server

    log(response.toString(), name: 'sdk hash ');
    // await getServerHash().then((value) {
    print(response.toString());
    var res;
    try{
    res= await getServerHash(jsonEncode(response), HashService.UuidtxnId);
    }catch(e){
      _checkoutPro.hashGenerated(hash: {'hashName':'1234'});
      // Navigator.canPop(context);
    // _checkoutPro.delegate?.onError(res);


      // showAlertDialog(context, "onError", e.toString());
    }
        // {"get_sdk_configuration":value };
        // log(hashResponse.toString(), name: 'generated hash response');
        ;
    // });

    //Keep the salt and hash calculation logic in the backend for security reasons. Don't use local hash logic.
    //Uncomment following line to test the test hash.
    // var  hashResponse = HashService.generateHash(response);
    // _checkoutPro.hashGenerated(hash: hashResponse);
  }

  @override
  void initState() {
    super.initState();
    _checkoutPro = PayUCheckoutProFlutter(this);
  }

  @override
  onError(Map? response) {
    log(response.toString(), name: 'error');
    showAlertDialog(context, "onError", response.toString());
  }

  @override
  onPaymentCancel(Map? response) {
    log(response.toString(), name: 'cancel');
    showAlertDialog(context, "onPaymentCancel", response.toString());
  }

  @override
  onPaymentFailure(dynamic response) {
    log(response.toString(), name: 'fails');
    showAlertDialog(context, "onPaymentFailure", response.toString());
  }

  @override
  onPaymentSuccess(dynamic response) {
    log(response.toString(), name: 'responnse');
    showAlertDialog(context, "onPaymentSuccess", response.toString());
  }

  String getSHA512Hash(String hashData) {
    var bytes = utf8.encode(hashData); // data being hashed
    var hash = sha512.convert(bytes);
    return hash.toString();
  }

//
  Future<Map> getServerHash(String hash, String txnId) async {
// var body =
    FormData data = FormData.fromMap({
      "action": "27",
      "mode": "8",
//  "key":"Tggnk3",
      "txnid": txnId,
      "DueAmount": "21.00",
      "sname": "s401",
      "email": "SHivanshu@abc.com",
      "feename": "academicfee",
      "instId": "1",
//  "salt":"",
      "UserId": "3018",
      "number": "9865985698",
      "LoginId": "s401",
      "AcademicYear": "47",
      "misctype": "1&10944120&30&3&1",
// instId:1
      "fdFeeType": "1",
      "demandId": "86a7728a-2e2a-11ef-b67a-02700c6f9e91",
      "sdkhash": "{hashString: Tbbek3|payment_related_details_for_mobile_sdk|Tggnk3:abc@gmail.com|, hashName: payment_related_details_for_mobile_sdk}"
    });
// Response response ;\
BaseOptions options=BaseOptions(
  connectTimeout: Duration(seconds: 3),
  receiveTimeout: Duration(seconds: 3),
  sendTimeout: Duration(seconds: 3))

;
    Dio _dio = Dio(options);
   
    
// var resdata;
    try {
// var url = Uri.parse("https://rr.pesuacademy.com/MAcademy/mobile/dispatcher");
      var headers = {
        'mobileAppAuthenticationToken':
            'D3iJWqENvrEQHQ6qxyUx9MgptxdTWxA3s2eDSHee4wMJqZs0NbTKaaF07hqWoE7lVtnymYMYcvCadpRgK4T7ORt11zQwZkkB'
      };
      // log(jsonEncode(data));
      var response = await _dio.post(
          'https://www.pesuacademy.com/MAcademy/mobile/dispatcher',
          data: data,
          options: Options(headers: headers));
// request.headers.addAll(headers);
// request.fields.addAll(body);
// response = await request.send();
      if (response.statusCode == 200) {
        log("rr respmse" + "${response.data}");
        _checkoutPro.hashGenerated(hash: response.data);
        //   resdata =response.data as Map;
        // return resdata;
      } else {
        // _checkoutPro.hashGenerated(hash: response.data);
        // Navigator.of(context).pop();
        print(response.statusMessage);
        throw Exception(response.statusMessage);
      }
    } catch (e, s) {
      
      log(e.toString(), error: s);
      throw Exception(e.toString());
    }
    return {"res": "NO Data"};
  }

  showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:  Text(content),
            ),
            actions: [okButton],
          );
        });
  }

  // var uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PayU Checkout Pro'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                child: const Text("Start Payment"),
                onPressed: () async {
                  String uuuuid = HashService.getUuid();
                  log(uuuuid.toString(), name: 'uuid');
                  log(HashService.UuidtxnId, name: 'hash uuid');
                  log(StaticPayuHsh.testparam.toString(), name: 'test parama');
                  log(StaticPayuHsh.additionalParam.toString(),
                      name: 'additional parama');
                  log(PayUParams.createPayUConfigParams().toString(),
                      name: 'payu config');
                  _checkoutPro.openCheckoutScreen(
                    payUPaymentParams: StaticPayuHsh.testparam,
                    payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
                  );
                    log(paymentHAh, name: 'payuparamd');
                  log( HashService.getSHA512Hash(paymentHAh), name: 'payuparamd');
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                child: const Text("hash "),
                onPressed: () async {
                  // import 'dart:convert';
// import 'dart:io';

// void main() {
  // Define parameters
  var apppVersion = "3.0.2";
  var time = DateTime.now().millisecondsSinceEpoch.toString();
  String pesID = "s401";
  String amount = '1';
  var platform = Platform.isAndroid ? "Android" : "Ios";
  String userId = "3018";
  String productInfo = 'academic fee';
  String academicyear = '47';
  String firstName = "Student401";

  // Encode parameters into a JSON string
  var parameters = {
    'apppVersion': apppVersion,
    'time': time,
    'pesID': pesID,
    'amount': amount,
    'platform': platform,
    'userId': userId,
    'productInfo': productInfo,
    'academicyear': academicyear,
    'firstName': firstName
  };

  var jsonString = jsonEncode(parameters);

  // Encode JSON string into Base64
  var txnid = base64Url.encode(utf8.encode(jsonString));
  print('Generated txnid: $txnid');

  // Decode Base64 string back to JSON string
  var decodedJsonString = utf8.decode(base64Url.decode(txnid));
  var decodedParams = jsonDecode(decodedJsonString);

  // Print decoded parameters
  print('Decoded Parameters: $decodedParams');
// }


                  // var uuid = Uuid();
                  // log(uuid.v7obj().toString(), name: 'uuid');
                
                  // log(PayUParams.createPayUConfigParams().toString(), name: 'payu config');
                  //                    const merchantSalt = "";// Add you Salt here.
                  //                  var  hashName= "payment_related_details_for_mobile_sdk";
//                     String hashStringWithoutSalt = "|17165356540|10|payu|shivanshu pal|shivanshu.p.com|shivashu|shivanshu..com|101|android|pesu||||||";
//                        var hashDataWithSalt = hashStringWithoutSalt + merchantSalt;
//                            generatedHash = getSHA512Hash(hashDataWithSalt);
//   // var finalHash = {hashName: generatedHash};
//   log(generatedHash.toString(), name: 'final hash');
//   var hash ="{hashString: 5Tnnd|1716535661540|10|payu|shivanshu |shivanshu.com|shivashu|shivanshu.com|101|android|pedeu||||||, hashName: payment_source}";
//  var res= await getServerHash(hash);

//  log(res.toString(), name: 'serveer hash');
                  // _checkoutPro.openCheckoutScreen(
                  //   payUPaymentParams: PayUParams.createPayUPaymentParams(),
                  //   payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
                  // );
                },
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Text(generatedHash)
          ],
        ),
      ),
    );
  }
}

class PayUTestCredentials {
  static const androidFurl =
      "https://www.pesuacademy.com/MAcademy/payment/PayuPaymentResponse/failed";
  static const androidSurl =
      "https://www.pesuacademy.com/MAcademy/payment/PayuPaymentResponse/success";
  static const iosFurl =
      "https://www.pesuacademy.com/MAcademy/payment/PayuPaymentResponse/failed";
  static const iosSurl =
      "https://wwww.pesuacademy.com/MAcademy/payment/PayuPaymentResponse/success";
  // static const testmerchantKey = "Kc9iwJ"; // Add you Merchant Key
  static const livemerchantKey = ""; // Add you Merchant Key

  // static const merchantAccessKey = "";//Add Merchant Access Key - Optional
  // static const sodexoSourceId = ""; //Add sodexo Source Id - Optional
}

// var merchantSalt = "mMprU4id";
var apppVersion = "3.0.2";
var time = DateTime.now().millisecondsSinceEpoch;
String pesID = "s401";
String amount = '1';
var platform = Platform.isAndroid ? "Android" : "Ios";
String userId = "3018";
String productInfo = 'academic fee';
String academicyear = '47';
String firstName = "Student401";
String email = "abc@gmail.com";
String phone = "778887";
String miss = '1&10944120&30&3&1';
var userCredential = "${PayUTestCredentials.livemerchantKey}:abc@gmail.com";

///\key|txnid|amount|productinfo|firstname|email |udf1|udf2| udf3|udf4|udf5||||||salt
var paymentHAh =
    "${PayUTestCredentials.livemerchantKey}|${HashService.UuidtxnId}|$amount|$productInfo|$firstName|$email|$userId|$phone|$pesID|$academicyear|$miss||||||${HashService.livemerchantSalt}";
// var paymentHash = HashService.getSHA512Hash(paymentHAh);

// //<key>|payment_related_details_for_mobile_sdk|<userCredential>|<salt>
// var paymenntrelatedahsh =
//     '${PayUTestCredentials.testmerchantKey}|payment_related_details_for_mobile_sdk|$userCredential|${HashService.livemerchantSalt}';
// var paymenntrelatedahsha = HashService.getSHA512Hash(paymenntrelatedahsh);

// //get_sdk_configuration

// var get_sdk_configuration =
//     "${PayUTestCredentials.testmerchantKey}|get_sdk_configuration|GET|${{HashService.livemerchantSalt}}";
// var getSdkCOnfig = HashService.getSHA512Hash(get_sdk_configuration);

// //
// //<key>|get_payment_details|<userCredential|<salt>
// var get_payment_details =
//     "${PayUTestCredentials.testmerchantKey}|get_payment_details|$userCredential|${HashService.livemerchantSalt}";
// var getPaymentHash = HashService.getSHA512Hash(get_payment_details);

///
//<key>|eligibleBinsForEMI|default|<salt>
// var eligibleBinsForEMI = "${PayUTestCredentials.testmerchantKey}|eligibleBinsForEMI|default|${HashService.livemerchantSalt}";
// var eligibleBinsForEMIHash = HashService.getSHA512Hash(eligibleBinsForEMI);
///
//
//<key> |get_payment_instrument|<userCredential|<salt>
// var get_payment_instrument =
//     "${PayUTestCredentials.testmerchantKey}|get_payment_instrument|$userCredential|${HashService.livemerchantSalt}";

// var get_payment_instrument_Hash =
//     HashService.getSHA512Hash(get_payment_instrument);

class StaticPayuHsh {
  static var additionalParam = {
    // "payment_related_details_for_mobile_sdk": paymenntrelatedahsha,
    // "Payment": paymentHash,
    // "get_sdk_configuration": getSdkCOnfig,
    // "get_payment_details":getPaymentHash,
    // "get_payment_instrument":get_payment_instrument_Hash,
    // "eligibleBinsForEMI":eligibleBinsForEMIHash,
    PayUAdditionalParamKeys.udf1: userId,
    PayUAdditionalParamKeys.udf2: phone,
    PayUAdditionalParamKeys.udf3: pesID,
    PayUAdditionalParamKeys.udf4: academicyear,
    PayUAdditionalParamKeys.udf5: miss,
    // PayUAdditionalParamKeys.merchantAccessKey:
    //     PayUTestCredentials.merchantAccessKey,
    // PayUAdditionalParamKeys.sourceId:PayUTestCredentials.sodexoSourceId,
  };

  static var testparam = {
    PayUPaymentParamKey.key: PayUTestCredentials.livemerchantKey,
    PayUPaymentParamKey.amount: amount,
    PayUPaymentParamKey.productInfo: productInfo,
    PayUPaymentParamKey.firstName: firstName,
    PayUPaymentParamKey.email: email,
    PayUPaymentParamKey.phone: phone,
    PayUPaymentParamKey.environment: "0",
    PayUPaymentParamKey.additionalParam: StaticPayuHsh.additionalParam,
    PayUPaymentParamKey.enableNativeOTP: true,
    // String - "0" for Production and "1" for Test
    PayUPaymentParamKey.transactionId: HashService.UuidtxnId,
    // transactionId Cannot be null or empty and should be unique for each transaction. Maximum allowed length is 25 characters. It cannot contain special characters like: -_/
    PayUPaymentParamKey.userCredential: userCredential,
    //  Format: <testmerchantKey>:<userId> ... UserId is any id/email/phone number to uniquely identify the user.
    PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl,
    PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl,
    PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl,
    PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl
  };
}

//Pass these values from your app to SDK, this data is only for test purpose
class PayUParams {
//   static Map createPayUPaymentParams() {
    // var siParams = {
    //   PayUSIParamsKeys.isFreeTrial: true,
    //   PayUSIParamsKeys.billingAmount: '1',              //Required
    //   PayUSIParamsKeys.billingInterval: 1,              //Required
    //   PayUSIParamsKeys.paymentStartDate: '2023-05-13',  //Required
    //   PayUSIParamsKeys.paymentEndDate: '2023-05-13',    //Required
    //   PayUSIParamsKeys.billingCycle:                    //Required
    //       'daily', //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
    //   PayUSIParamsKeys.remarks: 'Test SI transaction',
    //   PayUSIParamsKeys.billingCurrency: 'INR',
    //   PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
    //   PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
    // };

// var spitPaymentDetails =
//    {
//      "type": "absolute",
//      "splitInfo": {
//        PayUTestCredentials.testmerchantKey: {
//         "aggregatorSubTxnId": "${pesID}101${amount}06$batch", //unique for each transaction
//          "aggregatorSubAmt": "1"
//        }
//      }
//    };

//     var payUPaymentParams = {
//       PayUPaymentParamKey.key: PayUTestCredentials.testmerchantKey,
//       // PayUPaymentParamKey.amount: "100",
//       PayUPaymentParamKey.productInfo: "payu",
//       PayUPaymentParamKey.firstName: "SHIVANSHU",
//       PayUPaymentParamKey.email: "test@gmail.com",
//       PayUPaymentParamKey.phone: "9999999999",
//       PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl,
//       PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl,
//       PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl,
//       PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl,
//       PayUPaymentParamKey.environment: "1", //0 => Production 1 => Test

//       // PayUPaymentParamKey.userCredential:"$PayUTestCredentials.testmerchantKey,:$pesID", //Pass user credential to fetch saved cards => A:B - Optional
//       // PayUPaymentParamKey.transactionId:"${pesID}101${amount}06$batch", //DateTime.now().millisecondsSinceEpoch.toString()
//       // PayUPaymentParamKey.additionalParam: additionalParam,
//       PayUPaymentParamKey.enableNativeOTP: "true",
//       // PayUPaymentParamKey.splitPaymentDetails:json.encode(spitPaymentDetails),
//       // PayUPaymentParamKey.userToken:"", //Pass a unique token to fetch offers. - Optional
//     };

//     return payUPaymentParams;
//   }

  static Map createPayUConfigParams() {
    var paymentModesOrder = [
      {"UPI": "Google Pay"},
      {"UPI": "PHONEPE"},
      {"UPI": "PAYTM"},
      {"CARD": ""},
      {"UPI_INTENT": ""},
      {"NB": ""},
    ];

    var cartDetails = [
      {"GST": "5%"},
      {"Delivery Date": "25 Dec"},
      {"Status": "In Progress"}
    ];
    var enforcePaymentList = [
      {"payment_type": "CARD"},
      {"payment_type": "L1_OPTION"},
      {"payment_type": "NB"},
      {"payment_type": "UPI"},
      {"payment_type": "UPI_INTENT"},
      {"payment_type": "NEFTRTGS",},
    ];

     var customNotes = [
      {
        "custom_note": "Its Common custom note for testing purpose",
        "custom_note_category": [PayUPaymentTypeKeys.emi,PayUPaymentTypeKeys.card]
      },
      {
        "custom_note": "Payment options custom note",
        "custom_note_category": null
      }
    ];

    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "PES University",
      PayUCheckoutProConfigKeys.merchantLogo: "@drawable/peslogo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      PayUCheckoutProConfigKeys.cartDetails: cartDetails,

      // PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 50000,
      PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 50000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,
    };
    return payUCheckoutProConfig;
  }
}

///
///
///
//

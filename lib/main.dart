import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
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
String generatedHash='';

  late PayUCheckoutProFlutter _checkoutPro;

  @override
  generateHash(Map response) async{
    // Backend will generate the hash which you need to pass to SDK
    // hashResponse: is the response which you get from your server

    log(response.toString(), name: 'sdk hash ');
    // await getServerHash().then((value) {

    Map hashResponse =HashService.generateHash(response);
    // {"get_sdk_configuration":value };
    // log(hashResponse.toString(), name: 'generated hash response');
    _checkoutPro.hashGenerated(hash: hashResponse);
    // });

    //Keep the salt and hash calculation logic in the backend for security reasons. Don't use local hash logic. 
    //Uncomment following line to test the test hash.  
    // hashResponse = HashService.generateHash(response);
    
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

  Future<String> getServerHash()async{
    
var body ={
  "action":"27",
"mode":"8",
"key":"Kc9iwJ",
"txnid":"ca802100-7550-1fce-9b5c-756fbdda9c5c",
"DueAmount":"21.00",
"sname":"Shivanshu",
"email":"SHivanshu.pal@ayotta.com",
"feename":"academicfee",
"salt":"mMprU4id",
"UserId":"0ea9e95b-0c03-4969-8235-da5695821066",
"number":"9865985698",
"LoginId":"pes1201800002",
"AcademicYear":"21",
"misctype":"1",
};
late https.Response response ;
try{
// var url = Uri.parse("https://rr.pesuacademy.com/MAcademy/mobile/dispatcher");
var headers = {
  'mobileAppAuthenticationToken': 'D3iJWqENvrEQHQ6qxyUx9MgptxdTWxA3s2eDSHee4wMJqZs0NbTKaaF07hqWoE7lVtnymYMYcvCadpRgK4T7ORt11zQwZkkB'};
  log(jsonEncode(body));
 response =await https.post( Uri.parse('https://rr.pesuacademy.com/MAcademy/mobile/dispatcher'),body: body, headers: headers);
// request.headers.addAll(headers);
// request.fields.addAll(body);
// response = await request.send();

if (response.statusCode == 200) {
  print( response.body);
  return response.body;
}
else {
  print(response.reasonPhrase);
}
  }catch(e){
    print(e);
  }
 return response.body;
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
              child: new Text(content),
            ),
            actions: [okButton],
          );
        });
  }

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
              
                    log(StaticPayuHsh.  testparam.toString(), name: 'test parama');
                    log(StaticPayuHsh.additionalParam.toString(), name: 'additional parama');
                    log(PayUParams.createPayUConfigParams().toString(), name: 'payu config');
                  _checkoutPro.openCheckoutScreen(
                    payUPaymentParams:StaticPayuHsh.  testparam,
                    payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
                  );
                },
              ),
            ),
            const SizedBox(height: 50,),
            Center(
              child: ElevatedButton(
                child: const Text("hash "),
                onPressed: () async {
                  var uuid = Uuid();
                 log( uuid.v8obj().toString(), name: 'uuid');
                    log(  time.toString(), name: 'payuparamd');
                    // log(PayUParams.createPayUConfigParams().toString(), name: 'payu config');
  //                    const merchantSalt = "mMprU4id";// Add you Salt here. 
  //                  var  hashName= "payment_related_details_for_mobile_sdk";
  //                   String hashStringWithoutSalt = 'Kc9iwJ|payment_related_details_for_mobile_sdk| PES12018000002|';
  //                      var hashDataWithSalt = hashStringWithoutSalt + merchantSalt;
  //                          generatedHash = getSHA512Hash(hashDataWithSalt);
  // var finalHash = {hashName: generatedHash};
  // log(finalHash.toString(), name: 'final hash');
  getServerHash();
                  // _checkoutPro.openCheckoutScreen(
                  //   payUPaymentParams: PayUParams.createPayUPaymentParams(),
                  //   payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
                  // );
                },
              ),
            ),

const SizedBox(height: 80,),
            Text(generatedHash)
          ],
        ),
      ),
    );
  }
}

class PayUTestCredentials { 
  static const androidFurl = "https://cbjs.payu.in/sdk/failure";
  static const androidSurl = "https://cbjs.payu.in/sdk/success";
  static const iosFurl = "https://cbjs.payu.in/sdk/failure";
  static const iosSurl = "https://cbjs.payu.in/sdk/success";
  //Find the test credentials from dev guide: https://devguide.payu.in/flutter-sdk-integration/getting-started-flutter-sdk/mobile-sdk-test-environment/
  static const merchantKey = "Tggnk3";// Add you Merchant Key

  // static const merchantAccessKey = "";//Add Merchant Access Key - Optional
  // static const sodexoSourceId = ""; //Add sodexo Source Id - Optional
}


       var merchantSalt = "XGnf2PQnMT1tXTGVB01CVYDpnXBVkwCB";
     var apppVersion = "3.0.2";
     var time = DateTime.now().millisecondsSinceEpoch;
String pesID =" PES12018000110102";
String amount = '1';
String productInfo='Payu';
String batch = '202425';
String firstName ="Shivanshu Pal";
String email="shivanshus.pal@ayotta.com";
String phone = "8420406877";
var userCredential= "${PayUTestCredentials.merchantKey}:shivanshus.pal@ayotta.com";
var platform = Platform.isAndroid?"Android":"Ios";
    var payuTxID = "101${amount}06$time";
    ///\key|txnid|amount|productinfo|firstname|email |udf1|udf2| udf3|udf4|udf5||||||salt
var paymentHAh = "${PayUTestCredentials.merchantKey}|$payuTxID|1|$productInfo|$firstName|$email |$pesID|101| $platform|$apppVersion||||||$merchantSalt";
    var paymentHash = HashService.getSHA512Hash(paymentHAh);


//<key>|payment_related_details_for_mobile_sdk|<userCredential>|<salt>
var paymenntrelatedahsh= '${PayUTestCredentials.merchantKey}|payment_related_details_for_mobile_sdk|$userCredential|$merchantSalt';
    var paymenntrelatedahsha = HashService.getSHA512Hash(paymenntrelatedahsh);

//get_sdk_configuration

var get_sdk_configuration="${PayUTestCredentials.merchantKey}|get_sdk_configuration|GET|$merchantSalt";
var getSdkCOnfig = HashService.getSHA512Hash(get_sdk_configuration);

//
//<key>|get_payment_details|<userCredential|<salt>
var get_payment_details = "${PayUTestCredentials.merchantKey}|get_payment_details|$userCredential|$merchantSalt";
var getPaymentHash = HashService.getSHA512Hash(get_payment_details);

///
//<key>|eligibleBinsForEMI|default|<salt>
// var eligibleBinsForEMI = "${PayUTestCredentials.merchantKey}|eligibleBinsForEMI|default|$merchantSalt";
// var eligibleBinsForEMIHash = HashService.getSHA512Hash(eligibleBinsForEMI);
///
//
//<key> |get_payment_instrument|<userCredential|<salt>
var  get_payment_instrument="${PayUTestCredentials.merchantKey}|get_payment_instrument|$userCredential|$merchantSalt";

var get_payment_instrument_Hash = HashService.getSHA512Hash(get_payment_instrument);
class StaticPayuHsh{
  static  var additionalParam = {
      "payment_related_details_for_mobile_sdk":paymenntrelatedahsha,
      "Payment":paymentHash,
      "get_sdk_configuration":getSdkCOnfig,
      // "get_payment_details":getPaymentHash,
      // "get_payment_instrument":get_payment_instrument_Hash,
      // "eligibleBinsForEMI":eligibleBinsForEMIHash,
      PayUAdditionalParamKeys.udf1: pesID,
      PayUAdditionalParamKeys.udf2: "101",
      PayUAdditionalParamKeys.udf3: platform,
      PayUAdditionalParamKeys.udf4:apppVersion,
      // PayUAdditionalParamKeys.udf5:time,
      // PayUAdditionalParamKeys.merchantAccessKey:
      //     PayUTestCredentials.merchantAccessKey,
      // PayUAdditionalParamKeys.sourceId:PayUTestCredentials.sodexoSourceId,
    };

     static   var testparam = {
                PayUPaymentParamKey.key:PayUTestCredentials.merchantKey,
                PayUPaymentParamKey.amount: amount,
                PayUPaymentParamKey.productInfo: productInfo,
                PayUPaymentParamKey.firstName: firstName,
                PayUPaymentParamKey.email:email,
                PayUPaymentParamKey.phone: phone,
                PayUPaymentParamKey.environment: "0",
                PayUPaymentParamKey.additionalParam:StaticPayuHsh.additionalParam,
                PayUPaymentParamKey.enableNativeOTP: true,
                // String - "0" for Production and "1" for Test
                PayUPaymentParamKey.transactionId: payuTxID,
                // transactionId Cannot be null or empty and should be unique for each transaction. Maximum allowed length is 25 characters. It cannot contain special characters like: -_/
                PayUPaymentParamKey.userCredential:userCredential,
                //  Format: <merchantKey>:<userId> ... UserId is any id/email/phone number to uniquely identify the user.
                PayUPaymentParamKey.android_surl:
                    "https://cbjs.payu.in/sdk/success",
                PayUPaymentParamKey.android_furl:
                 "https://cbjs.payu.in/sdk/failure",
                PayUPaymentParamKey.ios_surl:
                    "https:///www.payumoney.com/mobileapp/payumoney/success.php",
                PayUPaymentParamKey.ios_furl:
                    "https:///www.payumoney.com/mobileapp/payumoney/failure.php",
              };
}
//Pass these values from your app to SDK, this data is only for test purpose
class PayUParams {
//   static Map createPayUPaymentParams() {
//     // var siParams = {
//     //   PayUSIParamsKeys.isFreeTrial: true,
//     //   PayUSIParamsKeys.billingAmount: '1',              //Required
//     //   PayUSIParamsKeys.billingInterval: 1,              //Required
//     //   PayUSIParamsKeys.paymentStartDate: '2023-05-13',  //Required
//     //   PayUSIParamsKeys.paymentEndDate: '2023-05-13',    //Required
//     //   PayUSIParamsKeys.billingCycle:                    //Required
//     //       'daily', //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
//     //   PayUSIParamsKeys.remarks: 'Test SI transaction',
//     //   PayUSIParamsKeys.billingCurrency: 'INR',
//     //   PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
//     //   PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
//     // };


// // var spitPaymentDetails =
// //    {
// //      "type": "absolute",
// //      "splitInfo": {
// //        PayUTestCredentials.merchantKey: {
// //         "aggregatorSubTxnId": "${pesID}101${amount}06$batch", //unique for each transaction
// //          "aggregatorSubAmt": "1"
// //        }
// //      }
// //    };


//     var payUPaymentParams = {
//       PayUPaymentParamKey.key: PayUTestCredentials.merchantKey,
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
      
//       // PayUPaymentParamKey.userCredential:"$PayUTestCredentials.merchantKey,:$pesID", //Pass user credential to fetch saved cards => A:B - Optional
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
      {"CARD":""},
      {"UPI_INTENT":""},
      {"NB": ""},
     ];

    // var cartDetails = [
    //   {"GST": "5%"},
    //   {"Delivery Date": "25 Dec"},
    //   {"Status": "In Progress"}
    // ];
    var enforcePaymentList = [
      {"payment_type": "CARD", "enforce_ibiboCode": "UTIBENCC"},
      {"payment_type": "CARD", "enforce_ibiboCode": "UTIBENDC"},
      {"payment_type": "L1_OPTION", "enforce_ibiboCode": ""},
      {"payment_type": "NB", "enforce_ibiboCode": ""},
      {"payment_type": "UPI", "enforce_ibiboCode": ""},
      {"payment_type": "UPI_INTENT", "enforce_ibiboCode": ""},

      {"payment_type": "NEFTRTGS", "enforce_ibiboCode": ""},
    ];

    //  var customNotes = [
    //   {
    //     "custom_note": "Its Common custom note for testing purpose",
    //     "custom_note_category": [PayUPaymentTypeKeys.emi,PayUPaymentTypeKeys.card]
    //   },
    //   {
    //     "custom_note": "Payment options custom note",
    //     "custom_note_category": null
    //   }
    // ];

    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "PES University",
      PayUCheckoutProConfigKeys.merchantLogo: "@drawable/peslogo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      // PayUCheckoutProConfigKeys.cartDetails: cartDetails,
      
      // PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 50000,
      // PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      // PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 50000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,
    };
    return payUCheckoutProConfig;
  }
}


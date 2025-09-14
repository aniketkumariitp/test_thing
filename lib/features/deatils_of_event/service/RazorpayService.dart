// import 'package:flutter/material.dart';
// import 'package:hoodhappen_creator/utils/constants.dart';
// import 'package:hoodhappen_creator/utils/helper.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class RazorpayService {
//   late Razorpay _razorpay;

//   late BuildContext _context;
//   late String _userId;
//   late String _eventId;

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     try {
//       showDialog(
//         context: _context,
//         barrierDismissible: false,
//         builder: (_) => WillPopScope(
//           onWillPop: () async => false,
//           child: const Center(child: CircularProgressIndicator()),
//         ),
//       );
//       final res = await http.post(
//         Uri.parse("$baseUrl/api/event/join-events"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "userId": _userId,
//           "eventId": _eventId,
//           "paymentId": response.paymentId ?? "unknown",
//         }),
//       );

//       final result = jsonDecode(res.body);
//       if (res.statusCode == 200) {
//         debugPrint("✅ Event joined and payout done");
//         Helper().showSnackBar(
//           _context,
//           "🎉 Joined & Creator Paid Successfully!",
//         );

//         // ✅ Pop the loading dialog
//         Navigator.pop(_context);

//         // ✅ Then go back to previous screen
//         Navigator.pop(_context);
//       } else {
//         Navigator.pop(_context);
//         Navigator.pop(_context); // Remove loading
//         Helper().showSnackBar(
//           _context,
//           result["message"] ?? "❌ Failed after payment.",
//         );
//       }
//     } catch (e) {
//       Navigator.pop(_context); // Remove loading
//       debugPrint("❌ Error on backend call: $e");
//       Helper().showSnackBar(_context, "⚠️ Something went wrong.");
//     } finally {
//       _razorpay.clear();
//     }
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     debugPrint("❌ Payment failed: ${response.message}");
//     Helper().showSnackBar(
//       _context,
//       "❌ Payment failed: ${response.message ?? ''}",
//     );
//     _razorpay.clear();
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Helper().showSnackBar(
//       _context,
//       "💳 Wallet Selected: ${response.walletName}",
//     );
//     _razorpay.clear();
//   }

//   Future<void> startPayment({
//     required BuildContext context,
//     required String userId,
//     required String eventId,
//     required int amount,
//     required String email,
//     required String contact,
//   }) async {
//     _context = context;
//     _userId = userId;
//     _eventId = eventId;

//     _razorpay = Razorpay();

//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (res) async {
//       try {
//         _handlePaymentSuccess(res as PaymentSuccessResponse);
//       } catch (e) {
//         debugPrint("Handler error: $e");
//       }
//     });

//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (res) {
//       try {
//         _handlePaymentError(res as PaymentFailureResponse);
//       } catch (e) {
//         debugPrint("Handler error: $e");
//       }
//     });

//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (res) {
//       try {
//         _handleExternalWallet(res as ExternalWalletResponse);
//       } catch (e) {
//         debugPrint("Handler error: $e");
//       }
//     });

//     var options = {
//       'key': 'rzp_live_DvGaeP8thhFkvD', // replace with your Razorpay Key
//       'amount': amount * 100, // in paisa
//       'name': 'HoodHappen Event Join',
//       'description': 'Join event via UPI',
//       'prefill': {'contact': contact, 'email': email},
//       'external': {
//         'wallets': ['paytm', 'phonepe', 'googlepay'],
//       },
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('❌ Error opening Razorpay: $e');
//       Helper().showSnackBar(context, "Unable to open Razorpay");
//     }
//   }

//   void dispose() {
//     _razorpay.clear();
//   }
// }

// Future<int?> applyCoupon(
//   String code,
//   int originalPrice,
//   BuildContext context,
// ) async {
//   try {
//     final response = await http.post(
//       Uri.parse("$baseUrl/api/event/apply-coupon"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"code": code, "originalPrice": originalPrice}),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200 && data["success"] == true) {
//       // ensure finalPrice is parsed as int
//       if (data["finalPrice"] is int) {
//         return data["finalPrice"] as int;
//       } else if (data["finalPrice"] is double) {
//         return (data["finalPrice"] as double).toInt();
//       } else if (data["finalPrice"] is String) {
//         return int.tryParse(data["finalPrice"]) ?? originalPrice;
//       } else {
//         return originalPrice; // fallback
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(data["error"] ?? "Invalid coupon"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return null;
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Server error: $e"), backgroundColor: Colors.red),
//     );
//     print("❌❌ Exception -> $e");
//     return null;
//   }
// }

import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/utils/constants.dart';
import 'package:hoodhappen_creator/utils/helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;
  late BuildContext _context;
  late String _userId;
  late String _eventId;
  late int _amount; // Amount user is actually paying

  /// Handles payment success and sends correct amount to backend
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      // Show loading dialog
      showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );

      final res = await http.post(
        Uri.parse("$baseUrl/api/event/join-events"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": _userId,
          "eventId": _eventId,
          "paymentId": response.paymentId ?? "unknown",
          "amount": _amount, // ✅ Send the actual paid amount
        }),
      );

      final result = jsonDecode(res.body);

      Navigator.pop(_context); // Remove loading

      if (res.statusCode == 200) {
        Helper().showSnackBar(
          _context,
          "🎉 Joined & Creator Paid Successfully!",
        );
        Navigator.pop(_context); // Go back to previous screen
      } else {
        Helper().showSnackBar(
          _context,
          result["message"] ?? "❌ Failed after payment.",
        );
      }
    } catch (e) {
      Navigator.pop(_context); // Remove loading
      debugPrint("❌ Error on backend call: $e");
      Helper().showSnackBar(_context, "⚠️ Something went wrong.");
    } finally {
      _razorpay.clear();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("❌ Payment failed: ${response.message}");
    Helper().showSnackBar(
      _context,
      "❌ Payment failed: ${response.message ?? ''}",
    );
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Helper().showSnackBar(
      _context,
      "💳 Wallet Selected: ${response.walletName}",
    );
    _razorpay.clear();
  }

  /// Start payment and pass actual amount user will pay
  Future<void> startPayment({
    required BuildContext context,
    required String userId,
    required String eventId,
    required int amount, // amount to be charged (discounted or original)
    required String email,
    required String contact,
  }) async {
    _context = context;
    _userId = userId;
    _eventId = eventId;
    _amount = amount;

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (res) {
      try {
        _handlePaymentSuccess(res as PaymentSuccessResponse);
      } catch (e) {
        debugPrint("Handler error: $e");
      }
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (res) {
      try {
        _handlePaymentError(res as PaymentFailureResponse);
      } catch (e) {
        debugPrint("Handler error: $e");
      }
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (res) {
      try {
        _handleExternalWallet(res as ExternalWalletResponse);
      } catch (e) {
        debugPrint("Handler error: $e");
      }
    });

    var options = {
      'key': 'rzp_live_DvGaeP8thhFkvD', // Replace with your Razorpay Key
      'amount': amount * 100, // Amount in paisa
      'name': 'HoodHappen Event Join',
      'description': 'Join event via UPI',
      'prefill': {'contact': contact, 'email': email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('❌ Error opening Razorpay: $e');
      Helper().showSnackBar(context, "Unable to open Razorpay");
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}

/// Apply coupon API
Future<int?> applyCoupon(
  String eventId,
  String code,
  int originalPrice,
  BuildContext context,
) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/api/event/apply-coupon"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "code": code,
        "originalPrice": originalPrice,
        "eventId": eventId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      if (data["finalPrice"] is int) {
        return data["finalPrice"] as int;
      } else if (data["finalPrice"] is double) {
        return (data["finalPrice"] as double).toInt();
      } else if (data["finalPrice"] is String) {
        return int.tryParse(data["finalPrice"]) ?? originalPrice;
      } else {
        return originalPrice;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["error"] ?? "Invalid coupon"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Server error: $e"), backgroundColor: Colors.red),
    );
    debugPrint("❌❌ Exception -> $e");
    return null;
  }
}

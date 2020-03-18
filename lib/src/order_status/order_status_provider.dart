import 'package:dailypitpartner/src/models/order_status_response.dart';
import 'package:dailypitpartner/src/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';

abstract class IOrderStatusProvider {
  Future<dynamic> getAllOrderStatus();
}

class OrderStatusProvider implements IOrderStatusProvider {
  Client client = Client();

  final String kGetOrderStatus =
      '${Constants.baseUrl}/partnerGetOrderStatus.php';

  @override
  Future getAllOrderStatus() async {
    String freelancerId = Constants.prefs.getString(Constants.firebase_user_id);
    try {
      final response = await client.post(
        'http://dailypit.com/crmscripts/api/partnerapp/getOrderStatus.php',
        body: {'freelancerId': freelancerId},
      );
      var resultClass = await compute(jsonParserIsolate, response.body);
      OrderStatusResponse res = OrderStatusResponse.fromJson(resultClass);
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Map<String, dynamic> jsonParserIsolate(String res) {
    return jsonDecode(res);
  }
}

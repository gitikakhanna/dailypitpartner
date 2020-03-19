import 'dart:convert';
import 'package:dailypitpartner/src/models/category_response.dart';
import 'package:dailypitpartner/src/models/freelance_model.dart';
import 'package:dailypitpartner/src/models/my_order_model.dart';
import 'package:dailypitpartner/src/models/order_model.dart';
import 'package:http/http.dart';
import '../models/register_model.dart';
import 'dart:async';

final _root = 'http://dailypit.com/partnerscripts/';
final _reusableRoot = 'http://dailypit.com/crmscripts/';

class DailypitApiProvider {
  Client client = Client();

  Future<CategoryResponse> getCategories() async {
    final response = await client
        .get("http://dailypit.com/crmscripts/api/partnerapp/getCategory.php");
    return CategoryResponse.fromJson(json.decode(response.body) as Map);
  }

  Future<bool> registerUser(Register registerData) async {
    final response = await client.post(
      'http://dailypit.com/crmscripts/api/partnerapp/registerUser.php',
      body: json.encode(registerData.toJson()),
    );
    int res = int.parse(response.body);
    assert(res is int);
    if (res == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<MyOrderModel>> fetchNewSingleOrder(String orderId) async {
    final response = await client.post(
      'https://dailypit.com/crmscripts/api/partnerapp/getServiceOrder.php',
      body: {'orderid': orderId},
    );
    print(response.body);
    return (json.decode(response.body) as List).map((e) {
      return MyOrderModel.fromJson(e);
    }).toList();
  }

  Future<List<OrderModel>> fetchSingleOrder(String orderId) async {
    final response = await client.post(
      '$_reusableRoot/get_single_order.php',
      body: {'id': orderId},
    );
    print(response.body);
    return (json.decode(response.body) as List).map((e) {
      return OrderModel.fromJson(e);
    }).toList();
  }

  Future<bool> updateStatus(String orderId) async {
    final response = await client.post(
      'http://dailypit.com/crmscripts/api/partnerapp/updateServiceOrderStatus.php',
      body: {
        'orderid': orderId,
      },
    );
    int res = int.parse(response.body);
    assert(res is int);
    //print('response is $res');
    if (res == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updatePassword(String phoneNumber, String password) async {
    final response = await client.post(
      'http://dailypit.com/crmscripts/api/partnerapp/updatePassword.php',
      body: {
        'phone': phoneNumber,
        'password': password,
      },
    );
    int res = int.parse(response.body);
    assert(res is int);
    //print('response is $res');
    if (res == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateFCMToken(String uid, String fcmToken) async {
    try {
      final response = await client.post(
        'http://dailypit.com/crmscripts/api/partnerapp/updateFcmToken.php',
        body: json.encode({'uid': uid, 'fcmtoken': fcmToken}),
      );
      int res = int.parse(response.body);
      assert(res is int);
      //print('response is $res');
      if (res == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> acceptServiceOrder(String uid, String orderId) async {
    try {
      final response = await client.post(
        'http://dailypit.com/crmscripts/api/partnerapp/acceptServiceOrder.php',
        body: {'uid': uid, 'orderId': orderId},
      );
      int res = int.parse(response.body);
      assert(res is int);
      //print('response is $res');
      if (res == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<MyOrderModel>> fetchMyOrders(String freelancerId) async {
    final response = await client.post(
      'http://dailypit.com/crmscripts/api/partnerapp/getAssignedOrders.php', //'$_reusableRoot/get_assigned_orders.php',
      body: {'uid': freelancerId},
    );
    print('response is ${response.body}');
    return (json.decode(response.body) as List).map((e) {
      return MyOrderModel.fromJson(e);
    }).toList();
  }

  Future<List<FreelancerModel>> fetchFreelancerDetail(String uid) async {
    try {
      final response = await client.post(
        'http://dailypit.com/crmscripts/api/partnerapp/getFreelancerData.php',
        body: {'uid': uid},
      );
      return (json.decode(response.body) as List).map((e) {
        return FreelancerModel.fromJson(e);
      }).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
}

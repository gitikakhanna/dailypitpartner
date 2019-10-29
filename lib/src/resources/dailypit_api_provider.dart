import 'dart:convert';
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

  Future<bool> registerUser(Register registerData) async {
    final response = await client.post(
      '$_root/register_user.php',
      body: registerData.toMap(),
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
      '$_reusableRoot/get_single_order.php',
      body: {'id': orderId},
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
      '$_reusableRoot/update_status.php',
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
      '$_reusableRoot/change_freelancer_password.php',
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

  Future<List<OrderModel>> fetchMyOrders(String freelancerId) async {
    final response = await client.post(
      '$_reusableRoot/get_assigned_orders.php',
      body: {'id': freelancerId},
    );
    print('response is ${response.body}');
    return (json.decode(response.body) as List).map((e) {
      return OrderModel.fromJson(e);
    }).toList();
  }

  Future<List<FreelancerModel>> fetchFreelancerDetail(String email) async {
    try {
      final response = await client.post(
        '$_reusableRoot/get_freelancer_data.php',
        body: {'email': email},
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

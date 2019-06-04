import 'dart:convert';
import 'package:dailypitpartner/src/models/order_model.dart';
import 'package:http/http.dart';
import '../models/register_model.dart';
import 'dart:async';
final _root = 'http://dailypit.com/partnerscripts/';
final _reusableRoot = 'http://dailypit.com/crmscripts/';
class DailypitApiProvider{

  Client client = Client();
  
  Future<bool> registerUser(Register registerData) async{
    final response = await client.post(
      '$_root/register_user.php',
      body: registerData.toMap(),
    );
    int res = int.parse(response.body);
    assert(res is int);
    if(res == 1){
      return true;
    }
    else{
      return false;
    }
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
    print('response is $res');
    if (res == 1) {
      return true;
    } else {
      return false;
    }
  }

}
import 'dart:async';
import 'package:dailypitpartner/src/models/my_order_model.dart';
import 'package:dailypitpartner/src/models/order_model.dart';

import '../models/register_model.dart';
import 'dailypit_api_provider.dart';

class Repository {
  DailypitApiProvider apiProvider = DailypitApiProvider();

  Future<bool> registerUser(Register registerData) async {
    return await apiProvider.registerUser(registerData);
  }

  Future<List<OrderModel>> fetchSingleOrder(String orderId) async {
    return await apiProvider.fetchSingleOrder(orderId);
  }

  Future<List<MyOrderModel>> fetchNewSingleOrder(String orderId) async {
    return await apiProvider.fetchNewSingleOrder(orderId);
  }

  Future<bool> updateStatus(String orderId) async {
    return await apiProvider.updateStatus(orderId);
  }

  Future<List<OrderModel>> fetchMyOrders(String freelancerId) async {
    return await apiProvider.fetchMyOrders(freelancerId);
  }
}


import 'dart:async';
import '../models/register_model.dart';
import 'dailypit_api_provider.dart';

class Repository{
  DailypitApiProvider apiProvider = DailypitApiProvider();

  Future<bool> registerUser(Register registerData) async{
    return await apiProvider.registerUser(registerData);
  }
}

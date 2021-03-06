import 'dart:convert';

import 'package:dailypitpartner/src/models/target_response.dart';
import 'package:dailypitpartner/src/models/update_target_response.dart';
import 'package:dailypitpartner/src/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

abstract class ITargetProvider {
  Future<dynamic> getPartnerTarget();
  Future<dynamic> updatePartnerTarget(String value);
}

class TargetProvider implements ITargetProvider {
  Client client = Client();

  final String kUpdatePartnerTarget =
      '${Constants.baseUrl}/partnerUpdateTarget.php';

  final String kGetPartnerTarget = '${Constants.baseUrl}/partnerGetTarget.php';

  @override
  Future getPartnerTarget() async {
    String id = Constants.prefs.getString(Constants.sql_user_id);
    try {
      final response = await client.post(
        kGetPartnerTarget,
        body: {'id': id},
      );
      var resultClass = await compute(jsonParserIsolate, response.body);
      TargetResponse res = TargetResponse.fromJson(resultClass);
      Constants.prefs.setInt(Constants.current_target_id, res.id);
      Constants.prefs.setBool(Constants.isTargetCompleted, res.isCompleted);
      return res;
      //return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future updatePartnerTarget(String value) async {
    int id = Constants.prefs.getInt(Constants.current_target_id);
    try {
      final response = await client.post(
        "https://dailypit.com/crmscripts/partnerUpdateTarget.php",
        body: {
          'target_id': "$id",
          'value': value,
        },
      );
      var resultClass = await compute(jsonParserIsolate, response.body);
      UpdateTargetResponse res = UpdateTargetResponse.fromJson(resultClass);
      Constants.prefs.setBool(Constants.isTargetCompleted, res.completed);
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Map<String, dynamic> jsonParserIsolate(String res) {
    return jsonDecode(res);
  }
}

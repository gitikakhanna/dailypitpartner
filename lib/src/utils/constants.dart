import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const String baseUrl = "http://dailypit.com/crmscripts";

  static SharedPreferences prefs;

  static const String pref_logged_in = "loggedIn";
  static const String firebase_user_id = "firebaseUserId";
  static const String sql_user_id = "sqlUserId";
  static const String firebasse_email_id = "firebaseEmailID";
  static const String isTargetCompleted = "isTargetCompleted";
  static const String current_target_id = "currentTargetId";
  static const String current_target_code = "currentTargetCode";
}

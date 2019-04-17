import 'package:http/http.dart';
import '../models/register_model.dart';

final _root = 'http://dailypit.com/partnerscripts/';

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

}
import 'dart:convert';

class Register{
  String name;
  String email;
  String phoneno;
  String address;

  Register({
    this.name,
    this.email,
    this.phoneno,
    this.address,
  });

  Register.fromJson(Map<String, dynamic> parsedJson){
    name = parsedJson['name'];
    email = parsedJson['emailid'];
    phoneno = parsedJson['phoneno'];
    address = parsedJson['address'];
  }

  Map<String, String> toMap(){
    return <String, String>{
      "name": name,
      "emailid": email,
      "phoneno": phoneno,
      "address": address,
    };
  }
}
import 'category_response.dart';

class Register {
  String name;
  String email;
  String phoneno;
  String address;
  List<Categories> categories;

  Register(
      {this.name, this.email, this.phoneno, this.address, this.categories});

  Register.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneno = json['phoneno'];
    address = json['address'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneno'] = this.phoneno;
    data['address'] = this.address;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

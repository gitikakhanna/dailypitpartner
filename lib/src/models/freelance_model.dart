// class FreelancerModel {
//   String id;
//   String name;
//   String emailid;
//   String password;
//   String phoneno;
//   String address;
//   String categoryId;
//   String company;
//   String location;
//   String lat;
//   String long;
//   String servingDistance;
//   String experience;
//   String servingLocation;
//   String qualification;
//   String image;
//   String doc;
//   String code;
//   String status;
//   String fcmToken;
//   String uid;

//   FreelancerModel(
//       {this.id,
//       this.name,
//       this.emailid,
//       this.password,
//       this.phoneno,
//       this.address,
//       this.fcmToken,
//       this.categoryId,
//       this.company,
//       this.location,
//       this.lat,
//       this.code,
//       this.status,
//       this.uid,
//       this.long,
//       this.servingDistance,
//       this.experience,
//       this.servingLocation,
//       this.qualification,
//       this.image,
//       this.doc});

//   FreelancerModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     emailid = json['emailid'];
//     password = json['password'];
//     uid = json['uid'];
//     phoneno = json['phoneno'];
//     status = json['status'];
//     address = json['address'];
//     categoryId = json['category_id'];
//     company = json['company'];
//     location = json['location'];
//     lat = json['lat'];
//     long = json['long'];
//     fcmToken = json['fcm_token'];
//     servingDistance = json['serving_distance'];
//     experience = json['experience'];
//     servingLocation = json['serving_location'];
//     qualification = json['qualification'];
//     image = 'https://dailypit.com/laravelcrm/uploads/${json['image']}';
//     doc = json['doc'];
//     code = json['code'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['emailid'] = this.emailid;
//     data['password'] = this.password;
//     data['phoneno'] = this.phoneno;
//     data['code'] = this.code;
//     data['status'] = this.status;
//     data['address'] = this.address;
//     data['category_id'] = this.categoryId;
//     data['company'] = this.company;
//     data['location'] = this.location;
//     data['lat'] = this.lat;
//     data['long'] = this.long;
//     data['serving_distance'] = this.servingDistance;
//     data['experience'] = this.experience;
//     data['serving_location'] = this.servingLocation;
//     data['qualification'] = this.qualification;
//     data['image'] = this.image;
//     data['doc'] = this.doc;
//     return data;
//   }
// }

class FreelancerModel {
  String id;
  String code;
  String name;
  String company;
  String phoneno;
  String emailid;
  String address;
  String qualification;
  String experience;
  String location;
  String servingLocations;
  String image;
  String doc;
  String status;
  String password;
  String fcmToken;
  String uid;
  String createdAt;
  String updatedAt;

  FreelancerModel(
      {this.id,
      this.code,
      this.name,
      this.company,
      this.phoneno,
      this.emailid,
      this.address,
      this.qualification,
      this.experience,
      this.location,
      this.servingLocations,
      this.image,
      this.doc,
      this.status,
      this.password,
      this.fcmToken,
      this.uid,
      this.createdAt,
      this.updatedAt});

  FreelancerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    company = json['company'];
    phoneno = json['phoneno'];
    emailid = json['emailid'];
    address = json['address'];
    qualification = json['qualification'];
    experience = json['experience'];
    location = json['location'];
    servingLocations = json['serving_locations'];
    image = 'https://dailypit.com/laravelcrm/uploads/${json['image']}';
    doc = json['document'];
    status = json['status'];
    password = json['password'];
    fcmToken = json['fcm_token'];
    uid = json['uid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['company'] = this.company;
    data['phoneno'] = this.phoneno;
    data['emailid'] = this.emailid;
    data['address'] = this.address;
    data['qualification'] = this.qualification;
    data['experience'] = this.experience;
    data['location'] = this.location;
    data['serving_locations'] = this.servingLocations;
    data['image'] = this.image;
    data['document'] = this.doc;
    data['status'] = this.status;
    data['password'] = this.password;
    data['fcm_token'] = this.fcmToken;
    data['uid'] = this.uid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

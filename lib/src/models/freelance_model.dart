class FreelancerModel {
  String id;
  String name;
  String emailid;
  String password;
  String phoneno;
  String address;
  String categoryId;
  String company;
  String location;
  String lat;
  String long;
  String servingDistance;
  String experience;
  String servingLocation;
  String qualification;
  String image;
  String doc;

  FreelancerModel(
      {this.id,
      this.name,
      this.emailid,
      this.password,
      this.phoneno,
      this.address,
      this.categoryId,
      this.company,
      this.location,
      this.lat,
      this.long,
      this.servingDistance,
      this.experience,
      this.servingLocation,
      this.qualification,
      this.image,
      this.doc});

  FreelancerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    emailid = json['emailid'];
    password = json['password'];
    phoneno = json['phoneno'];
    address = json['address'];
    categoryId = json['category_id'];
    company = json['company'];
    location = json['location'];
    lat = json['lat'];
    long = json['long'];
    servingDistance = json['serving_distance'];
    experience = json['experience'];
    servingLocation = json['serving_location'];
    qualification = json['qualification'];
    image = json['image'];
    doc = json['doc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['emailid'] = this.emailid;
    data['password'] = this.password;
    data['phoneno'] = this.phoneno;
    data['address'] = this.address;
    data['category_id'] = this.categoryId;
    data['company'] = this.company;
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['serving_distance'] = this.servingDistance;
    data['experience'] = this.experience;
    data['serving_location'] = this.servingLocation;
    data['qualification'] = this.qualification;
    data['image'] = this.image;
    data['doc'] = this.doc;
    return data;
  }
}

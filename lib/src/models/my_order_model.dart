// class MyOrderModel{
//   String subCategoryName;//subcategory_name
//   String price;
//   String userId;//userid
//   String username;
//   String status;//status
//   String categoryName; // name
//   String orderId; //firestoreid
//   String freelancerName;//assigned_freelancer_name
//   String freelancerId;//assigned_freelancer_id
//   String rating;
//   String comment;

//   MyOrderModel.fromJson(Map<String,dynamic> parsedJson){
//     subCategoryName = parsedJson['subcategory_name'];
//     price = parsedJson['price'];
//     userId = parsedJson['userid'];
//     username = parsedJson['username'];
//     status = parsedJson['status'];
//     categoryName = parsedJson['name'];
//     orderId = parsedJson['firestoreid'];
//     freelancerName = parsedJson['assigned_freelancer_name'];
//     freelancerId = parsedJson['assigned_freelancer_id'];
//     rating = parsedJson['rating'];
//     comment = parsedJson['comment'];
//   }

//   Map<String,String> toMap(){
//     return <String,String>{
//       'price' : price,
//     'userId' : userId,
//     'username' : username,
//     'status' : status,
//     'categoryName' : categoryName,
//     'orderId' : orderId,
//     'freelancerName':freelancerName,
//     'freelancerId':freelancerId,
//     'rating':rating,
//     'comment':comment,
//     };
//   }

// }

class MyOrderModel {
  String orderid;
  String categoryid;
  String categoryname;
  String servicecode;
  String servicename;
  String servicetype;
  String servicecount;
  String price;
  String status;
  String uid;
  String username;
  String phoneno;
  String useraddress;
  String paymentstatus;
  String createdAt;

  MyOrderModel(
      {this.orderid,
      this.categoryid,
      this.categoryname,
      this.servicecode,
      this.servicename,
      this.servicetype,
      this.servicecount,
      this.price,
      this.status,
      this.uid,
      this.username,
      this.phoneno,
      this.useraddress,
      this.paymentstatus,
      this.createdAt});

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    orderid = json['orderid'];
    categoryid = json['categoryid'];
    categoryname = json['categoryname'];
    servicecode = json['servicecode'];
    servicename = json['servicename'];
    servicetype = json['servicetype'];
    servicecount = json['servicecount'];
    price = json['price'];
    status = json['status'];
    uid = json['uid'];
    username = json['username'];
    phoneno = json['phoneno'];
    useraddress = json['useraddress'];
    paymentstatus = json['paymentstatus'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderid'] = this.orderid;
    data['categoryid'] = this.categoryid;
    data['categoryname'] = this.categoryname;
    data['servicecode'] = this.servicecode;
    data['servicename'] = this.servicename;
    data['servicetype'] = this.servicetype;
    data['servicecount'] = this.servicecount;
    data['price'] = this.price;
    data['status'] = this.status;
    data['uid'] = this.uid;
    data['username'] = this.username;
    data['phoneno'] = this.phoneno;
    data['useraddress'] = this.useraddress;
    data['paymentstatus'] = this.paymentstatus;
    data['created_at'] = this.createdAt;
    return data;
  }
}

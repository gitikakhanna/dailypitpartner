
class OrderModel{
  String subCategoryName;//subcategory_name
  String price;
  String userId;//userid
  String username;
  String status;//status
  String categoryName; // name
  String orderId; //firestoreid
  String freelancerName;//assigned_freelancer_name
  String freelancerId;//assigned_freelancer_id
  String userAddress;//useraddress

  OrderModel.fromJson(Map<String,dynamic> parsedJson){
    subCategoryName = parsedJson['subcategory_name'];
    price = parsedJson['price'];
    userId = parsedJson['userid'];
    username = parsedJson['username'];
    status = parsedJson['status'];
    categoryName = parsedJson['name'];
    orderId = parsedJson['firestoreid'];
    freelancerName = parsedJson['assigned_freelancer_name'];
    freelancerId = parsedJson['assigned_freelancer_id'];
    userAddress = parsedJson['useraddress'];
  }

  Map<String,String> toMap(){
    return <String,String>{
      'price' : price,
    'userId' : userId,
    'username' : username,
    'status' : status,
    'categoryName' : categoryName,
    'orderId' : orderId,
    'freelancerName':freelancerName,
    'freelancerId':freelancerId,
    'useraddress':userAddress,
    };
  }

}
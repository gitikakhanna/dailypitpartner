class TargetResponse {
  int id;
  String userid;
  int achievedvalue;
  int targetvalue;
  String duedate;
  bool isCompleted;

  TargetResponse(
      {this.id,
      this.userid,
      this.achievedvalue,
      this.targetvalue,
      this.duedate,
      this.isCompleted});

  TargetResponse.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    userid = json['userid'];
    achievedvalue =
        json['achievedvalue'] == null ? 0 : int.parse(json['achievedvalue']);
    targetvalue =
        json['targetvalue'] == null ? 0 : int.parse(json['targetvalue']);
    duedate = json['duedate'];
    if (json['isCompleted'] == null) {
      isCompleted = false;
    } else if (json['isCompleted'] == "0") {
      isCompleted = false;
    } else if (json['isCompleted'] == "1") {
      isCompleted = true;
    } else {
      isCompleted = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['achievedvalue'] = this.achievedvalue;
    data['targetvalue'] = this.targetvalue;
    data['duedate'] = this.duedate;
    data['isCompleted'] = this.isCompleted;
    return data;
  }
}

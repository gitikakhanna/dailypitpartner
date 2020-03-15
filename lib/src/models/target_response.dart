class TargetResponse {
  int id;
  String userid;
  int achievedvalue;
  int targetvalue;
  String duedate;
  bool isCompleted;

  String beforeimage;
  String afterimage;
  String code;

  TargetResponse(
      {this.id,
      this.userid,
      this.code,
      this.beforeimage,
      this.afterimage,
      this.achievedvalue,
      this.targetvalue,
      this.duedate,
      this.isCompleted});

  TargetResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : int.parse(json['id']);

    code = json['code'];

    beforeimage =
        "https://dailypit.com/laravelcrm/uploads/${json['beforeimage']}";
    afterimage =
        "https://dailypit.com/laravelcrm/uploads/${json['afterimage']}";
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
    data['code'] = this.code;
    data['afterimage'] = this.afterimage;
    data['beforeimage'] = this.beforeimage;
    data['userid'] = this.userid;
    data['achievedvalue'] = this.achievedvalue;
    data['targetvalue'] = this.targetvalue;
    data['duedate'] = this.duedate;
    data['isCompleted'] = this.isCompleted;
    return data;
  }
}

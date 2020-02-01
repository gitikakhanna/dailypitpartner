class UpdateTargetResponse {
  bool completed;

  UpdateTargetResponse({this.completed});

  UpdateTargetResponse.fromJson(Map<String, dynamic> json) {
    if (json['completed'] == null ||
        json['completed'] == 0 ||
        json['completed'] == "0") {
      completed = false;
    } else if (json['completed'] == 1 || json['completed'] == "1") {
      completed = true;
    } else {
      completed = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completed'] = this.completed;
    return data;
  }
}

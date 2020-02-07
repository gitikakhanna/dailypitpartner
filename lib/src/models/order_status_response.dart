class OrderStatusResponse {
  String freelancerId;
  String completedCount;
  String assignedCount;

  OrderStatusResponse(
      {this.freelancerId, this.completedCount, this.assignedCount});

  OrderStatusResponse.fromJson(Map<String, dynamic> json) {
    freelancerId = json['freelancer_id'];
    completedCount = json['completed_count'];
    assignedCount = json['assigned_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['freelancer_id'] = this.freelancerId;
    data['completed_count'] = this.completedCount;
    data['assigned_count'] = this.assignedCount;
    return data;
  }
}

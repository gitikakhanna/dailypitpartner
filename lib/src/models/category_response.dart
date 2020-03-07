class CategoryResponse {
  List<Categories> categories;

  CategoryResponse({this.categories});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int categoryid;
  String categoryname;

  Categories({this.categoryid, this.categoryname});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryid = int.parse(json['categoryid']);
    categoryname = json['categoryname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryid'] = this.categoryid;
    data['categoryname'] = this.categoryname;
    return data;
  }
}

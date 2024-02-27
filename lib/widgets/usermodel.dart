class UserModel {
  String? email;
  String? uid;

  UserModel({
    this.email,
    this.uid,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['uid'] = uid;

    return data;
  }
}

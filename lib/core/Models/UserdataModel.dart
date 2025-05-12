// ignore_for_file: unnecessary_null_comparison

class UserModel {
  late String name;
  late String email;
  late String userId;
  late String passWord;
  late String study_Group;
  late String specialization;

  UserModel({
    required this.name,
    required this.email,
    required this.userId,
    required this.passWord,
    required this.study_Group,
    required this.specialization,

  });

  UserModel.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    } else {
      name = map["name"];
      email = map["email"];
      userId = map["userId"];
      passWord = map["passWord"];
      specialization = map["specialization"];
      study_Group = map["study_Group"];
    }
  }
  toJson() {
    return {
      "name": name,
      "email": email,
      "userId": userId,
      "passWord": passWord,
      "study_Group": study_Group,
      "specialization": specialization
    };
  }
}  
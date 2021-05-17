class UserModel {
  int id;
  String username;
  String role;
  int ministaryId;
  int patientId;
  int doctorId;
  int healthUnitId;

  UserModel(
      {this.id,
      this.username,
      this.role,
      this.ministaryId,
      this.patientId,
      this.doctorId,
      this.healthUnitId});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["Id"],
      username: json["Username"],
      role: json["Role"],
      ministaryId: json["Ministary_Id"],
      patientId: json["Patient_Id"],
      doctorId: json["Doctor_Id"],
      healthUnitId: json["Health_Unit_Id"],
    );
  }
}

class AppointmentModel {
  final String doctorFullname;
  final String unitName;
  final String unitAddress;
  final String appointmentDate;

  AppointmentModel(
      {this.doctorFullname,
      this.unitName,
      this.unitAddress,
      this.appointmentDate});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      doctorFullname: json["Doctor_FullName"],
      unitAddress: json["Unit_Adress"],
      unitName: json["Unit_Name"],
      appointmentDate: json["Appointment_Date"],
    );
  }
}

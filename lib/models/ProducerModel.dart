class ProducerModel {
  int id;
  String producerCountry;
  String producerName;
  String producerEmail;
  String producerPhone;
  String producerAddress;
  int ministaryId;
  String imageUrl;

  ProducerModel(
      {this.id,
      this.producerCountry,
      this.producerName,
      this.producerEmail,
      this.producerPhone,
      this.producerAddress,
      this.ministaryId,
      this.imageUrl});

  factory ProducerModel.fromJson(Map<String, dynamic> json) {
    return ProducerModel(
        id: json["Id"],
        producerCountry: json["Producer_Country"],
        producerName: json["Producer_Name"],
        producerEmail: json["Producer_Email"],
        producerPhone: json["Producer_Phone"],
        producerAddress: json["Producer_Adress"],
        ministaryId: json["Ministary_Id"],
        imageUrl: json["Image_Url"]);
  }
}

import 'package:alertify/alertify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_stock_app/data/AdminData.dart';
import 'package:flutter_stock_app/panels/LoginPanel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(left: 100, top: 10),
            child: FaIcon(FontAwesomeIcons.syringe),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    showModal(context);
                  },
                  icon: Icon(
                    Icons.app_registration,
                  ),
                ))
          ],
          title: Text(
            'Vaccine Stock',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          backgroundColor: Color.fromRGBO(23, 162, 184, 1),
        ),
        body: SafeArea(child: LoginPanel()),
        backgroundColor: Colors.white);
  }
}

showModal(context) async {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
            builder: (BuildContext context, setState) => SingleChildScrollView(
                  child: Container(
                      color: Colors.transparent,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          alignment: Alignment.topLeft,
                          child: Column(children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 5, left: 20),
                                  child: Text(
                                    "Kayıt Ol",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Color.fromRGBO(23, 162, 184, 1)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5, left: 5),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Kapat",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: const Color(0xfff8f8f8),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                padding: EdgeInsets.all(20)),
                                            onPressed: () {
                                              setState(() =>
                                                  showMinistaryModal(context));
                                            },
                                            child: Text("Bakanlık")),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                padding: EdgeInsets.all(20)),
                                            onPressed: () {
                                              setState(() =>
                                                  showProducerModal(context));
                                            },
                                            child: Text("Üretici")),
                                      )
                                    ],
                                  ),
                                ))
                          ]))),
                ));
      });
}

//#Register for producers
showProducerModal(context) async {
  final formKey = GlobalKey<FormState>();
  final producerName = TextEditingController();
  final producerCountry = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final producerEmail = TextEditingController();
  final producerPhone = TextEditingController();
  final producerAddress = TextEditingController();
  final producerImageUrl = TextEditingController();
  return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return SingleChildScrollView(
          child: Container(
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  alignment: Alignment.topLeft,
                  child: Column(children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "Kayıt Ol",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(23, 162, 184, 1)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 5),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Kapat",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: const Color(0xfff8f8f8),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              BootstrapRow(height: 80, children: [
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: producerName,
                                    decoration: InputDecoration(
                                      labelText: "Üretici Adı",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern pattern = r'^([a-zA-Z])';
                                      Pattern space = r"\s+";
                                      RegExp regex = new RegExp(pattern);
                                      RegExp spaceRegex = new RegExp(space);
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return 'Kelime giriniz';
                                      }
                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: producerCountry,
                                    decoration: InputDecoration(
                                      labelText: "Üretici Ülke",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern pattern = r'^([a-zA-Z])';
                                      Pattern space = r"\s+";
                                      RegExp regex = new RegExp(pattern);
                                      RegExp spaceRegex = new RegExp(space);
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return 'Kelime giriniz';
                                      }
                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ]),
                              BootstrapRow(height: 80, children: [
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: producerEmail,
                                    decoration: InputDecoration(
                                      labelText: "Üretici Email",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern space = r"\s+";

                                      RegExp spaceRegex = new RegExp(space);
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: producerPhone,
                                    decoration: InputDecoration(
                                      labelText: "Üretici Telefon",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }

                                      Pattern space = r"\s+";
                                      RegExp spaceRegex = new RegExp(space);

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ]),
                              BootstrapRow(height: 80, children: [
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: userName,
                                    decoration: InputDecoration(
                                      labelText: "Kullanıcı Adı",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      Pattern space = r"\s+";
                                      RegExp spaceRegex = new RegExp(space);

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: password,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Parola",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      Pattern space = r"\s+";
                                      RegExp spaceRegex = new RegExp(space);

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ]),
                              BootstrapRow(height: 80, children: [
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: producerAddress,
                                    decoration: InputDecoration(
                                      labelText: "Üretici Adresi",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern pattern = r'^([a-zA-Z])';
                                      Pattern space = r"\s+";
                                      RegExp regex = new RegExp(pattern);
                                      RegExp spaceRegex = new RegExp(space);
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return 'Kelime giriniz';
                                      }
                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: producerImageUrl,
                                    decoration: InputDecoration(
                                      labelText: "Resim Adresi",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      Pattern space = r"\s+";
                                      RegExp spaceRegex = new RegExp(space);

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ]),
                              BootstrapCol(
                                  sizes: 'col-6',
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromRGBO(23, 162, 184, 1),
                                        side: BorderSide(
                                          color: Colors.white,
                                        )),
                                    child: Text("Kaydet"),
                                    onPressed: () async {
                                      if (formKey.currentState.validate()) {
                                        Object producerObj = {
                                          "name": producerName.text,
                                          "country": producerCountry.text,
                                          "email": producerEmail.text,
                                          "phone": producerPhone.text,
                                          "address": producerAddress.text,
                                          "ministaryid": null,
                                          "img": producerImageUrl.text,
                                        };
                                        final response =
                                            await AdminData.createProducer(
                                                producerObj);

                                        if (response.statusCode == 200) {
                                          Map<String, dynamic> res =
                                              await AdminData
                                                  .getLastProducerId();

                                          Object userObj = {
                                            "username": userName.text,
                                            "password": password.text,
                                            "role": "producer",
                                            "ministary_id": null,
                                            "patient_id": null,
                                            "doctor_id": null,
                                            "unit_id": null,
                                            "producer_id": res["Id"]
                                          };
                                          var response =
                                              await AdminData.createUser(
                                                  userObj);
                                          if (response.statusCode == 200) {
                                            Navigator.pop(context);
                                            Alertify(
                                                    alertType:
                                                        AlertifyType.success,
                                                    context: context,
                                                    title: "Başarılı",
                                                    content:
                                                        "Kayıt işlemi başarılı.",
                                                    animationType: AnimationType
                                                        .bottomToTop,
                                                    buttonText: 'Ok',
                                                    isDismissible: true)
                                                .show();
                                          }
                                        }
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ))
                  ]))),
        );
      });
}

// #Register for countries
showMinistaryModal(context) async {
  final formKey = GlobalKey<FormState>();
  final countryName = TextEditingController();
  final countryNeeds = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final totalVaccine = TextEditingController();
  final countryImageUrl = TextEditingController();
  return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return SingleChildScrollView(
          child: Container(
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  alignment: Alignment.topLeft,
                  child: Column(children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "Kayıt Ol",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(23, 162, 184, 1)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 5),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Kapat",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: const Color(0xfff8f8f8),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              BootstrapRow(height: 80, children: [
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: countryName,
                                    decoration: InputDecoration(
                                      labelText: "Ülke Adı",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern pattern = r'^([a-zA-Z])';
                                      Pattern space = r"\s+";
                                      RegExp regex = new RegExp(pattern);
                                      RegExp spaceRegex = new RegExp(space);
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return 'Kelime giriniz';
                                      }
                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: countryNeeds,
                                    decoration: InputDecoration(
                                      labelText: "Ülke İhtiyacı",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern pattern = r'^[0-9]*$';
                                      RegExp regex = new RegExp(pattern);
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return 'Sayı giriniz';
                                      }

                                      Pattern space = r"\s+";
                                      RegExp spaceRegex = new RegExp(space);

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ]),
                              BootstrapRow(height: 80, children: [
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: userName,
                                    decoration: InputDecoration(
                                      labelText: "Kullanıcı Adı",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      Pattern space = r"\s+";
                                      RegExp spaceRegex = new RegExp(space);

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: password,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Parola",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      Pattern space = r"\s+";
                                      RegExp spaceRegex = new RegExp(space);

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ]),
                              BootstrapRow(height: 80, children: [
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: totalVaccine,
                                    decoration: InputDecoration(
                                      labelText: "Toplam Aşı",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      Pattern pattern = r'^[0-9]*$';
                                      RegExp regex = new RegExp(pattern);
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return 'Sayı giriniz';
                                      }
                                      Pattern space = r"\s+";
                                      RegExp spaceRegex = new RegExp(space);

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                BootstrapCol(
                                  sizes: 'col-6',
                                  child: TextFormField(
                                    controller: countryImageUrl,
                                    decoration: InputDecoration(
                                      labelText: "Resim Adresi",
                                      labelStyle:
                                          TextStyle(color: Colors.black87),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Değer giriniz';
                                      }
                                      Pattern space = r"\s+";
                                      RegExp spaceRegex = new RegExp(space);

                                      if (spaceRegex.hasMatch(value)) {
                                        return 'Boşluk kullanmayınız';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ]),
                              BootstrapCol(
                                  sizes: 'col-6',
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromRGBO(23, 162, 184, 1),
                                        side: BorderSide(
                                          color: Colors.white,
                                        )),
                                    child: Text("Kaydet"),
                                    onPressed: () async {
                                      DateTime today = DateTime.parse(
                                          DateTime.now().toString());
                                      if (formKey.currentState.validate()) {
                                        Object ministaryObj = {
                                          "name": countryName.text,
                                          "need": countryNeeds.text,
                                          "total": totalVaccine.text,
                                          "img": countryImageUrl.text,
                                          "lastdate": today
                                              .toIso8601String()
                                              .split('.')[0],
                                          "lastcount": 0
                                        };

                                        var response =
                                            await AdminData.createMinistary(
                                                ministaryObj);

                                        if (response.statusCode == 200) {
                                          Map<String, dynamic> res =
                                              await AdminData
                                                  .getLastMinistaryId();
                                          print(res["Id"]);
                                          Object userObj = {
                                            "username": userName.text,
                                            "password": password.text,
                                            "role": "admin",
                                            "ministary_id": res["Id"],
                                            "patient_id": null,
                                            "doctor_id": null,
                                            "unit_id": null,
                                            "producer_id": null
                                          };
                                          var response =
                                              await AdminData.createUser(
                                                  userObj);

                                          if (response.statusCode == 200) {
                                            Navigator.pop(context);

                                            Alertify(
                                                    alertType:
                                                        AlertifyType.success,
                                                    context: context,
                                                    title: "Başarılı",
                                                    content:
                                                        "Kayıt işlemi başarılı.",
                                                    animationType: AnimationType
                                                        .bottomToTop,
                                                    buttonText: 'Ok',
                                                    isDismissible: true)
                                                .show();
                                          }
                                        }
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ))
                  ]))),
        );
      });
}

showFullModal(context) {
  final key = GlobalKey();
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Modal",
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              "Modal",
              style: TextStyle(
                  color: Colors.black87, fontFamily: 'Overpass', fontSize: 20),
            ),
            elevation: 0.0),
        backgroundColor: Colors.white.withOpacity(0.90),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: const Color(0xfff8f8f8),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Değer giriniz';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

import 'dart:convert';

import 'package:alertify/alertify.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stock_app/views/AdminPage.dart';
import 'package:flutter_stock_app/views/DoctorPage.dart';
import 'package:flutter_stock_app/views/HealthUnitPage.dart';
import 'package:flutter_stock_app/views/PatientPage.dart';
import 'package:flutter_stock_app/views/ProducerPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_stock_app/data/AdminData.dart';
import 'package:flutter_stock_app/views/InfoPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';

class LoginPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPanelState();
  }
}

class LoginPanelState extends State<LoginPanel> {
  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.parse(DateTime.now().toString());
    print(today.toIso8601String().split('.')[0]);
  }

  Widget build(BuildContext context) {
    final storage = new FlutterSecureStorage();
    double screenHeight = MediaQuery.of(context).size.height;
    final _username = TextEditingController();
    final _password = TextEditingController();
    return BootstrapContainer(
        decoration: BoxDecoration(
            color: Color.fromRGBO(23, 162, 184, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3))
            ]),
        padding: EdgeInsets.all(10),
        fluid: true,
        children: [
          BootstrapRow(
            height: screenHeight,
            children: <BootstrapCol>[
              BootstrapCol(
                  child: Center(
                      child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: FaIcon(
                  FontAwesomeIcons.userLock,
                  size: 40,
                  color: Colors.white,
                ),
              ))),
              BootstrapCol(
                  sizes: 'col-md-12',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: TextField(
                      controller: _username,
                      cursorHeight: 25,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: 'Kullanıcı Adı',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  )),
              BootstrapCol(
                  sizes: 'col-md-12',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: TextField(
                      controller: _password,
                      cursorHeight: 25,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      obscureText: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: 'Parola',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  )),
              BootstrapCol(
                  sizes: 'col-md-12',
                  child: BootstrapRow(height: 50, children: [
                    BootstrapCol(
                      sizes: 'col-md-6',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InfoPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.arrowAltCircleLeft,
                                  color: Color.fromRGBO(23, 162, 184, 1),
                                ),
                                Text(
                                  "İptal",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromRGBO(23, 162, 184, 1),
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                        ),
                      ),
                    ),
                    BootstrapCol(
                      sizes: 'col-md-6',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              Object userObj = {
                                "username": _username.text,
                                "password": _password.text,
                              };
                              http.Response response =
                                  await AdminData.postUser(userObj);

                              if (response.statusCode == 401) {
                                Alertify(
                                        context: context,
                                        isDismissible: true,
                                        alertType: AlertifyType.error,
                                        title: "Giriş Başarısız",
                                        buttonText: 'Tamam',
                                        animationType:
                                            AnimationType.bottomToTop,
                                        content:
                                            "Hatalı Kullanıcı Adı Veya Parola")
                                    .show();
                              } else if (response.statusCode == 200) {
                                String token =
                                    jsonDecode(response.body)["accessToken"];
                                await storage.write(key: "token", value: token);
                                Map<String, dynamic> values =
                                    Jwt.parseJwt(token);
                                print(values["role"]);

                                switch (values["role"]) {
                                  case "admin":
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AdminPage()),
                                        (route) => false);
                                    break;
                                  case "healthunit":
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HealthUnitPage()),
                                        (route) => false);
                                    break;
                                  case "doctor":
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DoctorPage()),
                                        (route) => false);
                                    break;
                                  case "patient":
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PatientPage()),
                                        (route) => false);
                                    break;
                                  case "producer":
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProducerPage()),
                                        (route) => false);
                                    break;
                                }
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Giriş",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromRGBO(23, 162, 184, 1),
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.arrowAltCircleRight,
                                  color: Color.fromRGBO(23, 162, 184, 1),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                        ),
                      ),
                    ),
                  ]))
            ],
          ),
        ]);
  }
}

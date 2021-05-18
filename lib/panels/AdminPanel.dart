import 'package:alertify/alertify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stock_app/data/AdminData.dart';
import 'package:flutter_stock_app/models/DoctorModel.dart';
import 'package:flutter_stock_app/models/HealthUnitModel.dart';
import 'package:flutter_stock_app/models/MinistaryModel.dart';
import 'package:flutter_stock_app/models/ProducerModel.dart';
import 'package:flutter_stock_app/models/ProducerStockModel.dart';
import 'package:flutter_stock_app/models/ReportModel.dart';
import 'package:flutter_stock_app/models/UserModel.dart';
import 'package:flutter_stock_app/views/AdminPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';

// ignore: must_be_immutable
class AdminPanel extends StatefulWidget {
  bool openMenu;
  AdminPanel({this.openMenu});
  @override
  State<StatefulWidget> createState() {
    return AdminPanelState();
  }
}

class AdminPanelState extends State<AdminPanel> {
  int selectedIndex = 0;
  int ministaryId = 0;
  var storage = new FlutterSecureStorage();
  MinistaryModel ministaryInfos;
  List<ReportModel> reportList;
  List<ProducerModel> producerList;
  List<HealthUnitModel> unitList;
  List<ProducerStockModel> stockList;
  List<UserModel> userList;
  List<HealthUnitModel> notRegisteredUnitList;
  List<DoctorModel> notRegisteredDoctorList;
  List<Object> notRegisteredList = [];
  List<ProducerModel> notAddedProducerList;
  ProducerModel selectedProducer;
  ProducerModel selectedProducerToClaim;
  HealthUnitModel selectedUnitToAddDoctor;
  Object selectedUser;

  int totalNeed;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getMinistaryId();
  }

  getMinistaryId() async {
    var key = await storage.read(key: "token");
    var userObj = Jwt.parseJwt(key);
    this.ministaryId = userObj["ministary_id"];

    getData();
  }

  getData() async {
    List<UserModel> doctorUserList = [];
    List<UserModel> unitUserList = [];

    ministaryInfos = await AdminData.getMinistary(ministaryId);
    reportList = await AdminData.getReportsByMinistaryId(ministaryId);
    producerList = await AdminData.getProducersByMinistary(ministaryId);
    unitList = await AdminData.getUnitsByMinistary(ministaryId);
    stockList = await AdminData.getStockByMinistary(ministaryId);
    doctorUserList = await AdminData.getDoctorUsersByMinistaryId(ministaryId);
    unitUserList = await AdminData.getUnitUsersByMinistaryId(ministaryId);
    notRegisteredDoctorList =
        await AdminData.getNotRegisteredDoctorUsersByMinistaryId(ministaryId);
    notRegisteredUnitList =
        await AdminData.getNotRegisteredUnitUsersByMinistaryId(ministaryId);
    notAddedProducerList = await AdminData.getNotAddedProducers(ministaryId);

    notRegisteredList = new List.from(notRegisteredUnitList)
      ..addAll(notRegisteredDoctorList);

    if (notRegisteredList.isNotEmpty) selectedUser = notRegisteredList.first;

    if (notAddedProducerList.isNotEmpty)
      selectedProducer = notAddedProducerList.first;

    userList = doctorUserList + unitUserList;

    var total = reportList.fold(
        0, (previousValue, element) => previousValue += element.unitNeeds);

    totalNeed = total + ministaryInfos.ministaryNeeds;

    setState(() {
      loading = true;
    });

    print("total:$totalNeed");
  }

  showModal(context) async {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, setState) =>
                  SingleChildScrollView(
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
                                      "Birim Ekle",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                showUnitModal(context);
                                              },
                                              child: Text("Sağlık Birimi")),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color.fromRGBO(
                                                      23, 162, 184, 1),
                                                  padding: EdgeInsets.all(20)),
                                              onPressed: () {
                                                showDoctorModal(context);
                                              },
                                              child: Text("Doktor Birimi")),
                                        )
                                      ],
                                    ),
                                  ))
                            ]))),
                  ));
        });
  }

//#add for healthunit
  showUnitModal(context) async {
    final formKey = GlobalKey<FormState>();
    final unitName = TextEditingController();
    final unitPhone = TextEditingController();
    final unitAddress = TextEditingController();
    final unitImage = TextEditingController();
    final storage = new FlutterSecureStorage();
    int ministaryId = 0;
    var key = await storage.read(key: "token");
    var userObj = Jwt.parseJwt(key);
    ministaryId = userObj["ministary_id"];

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
                                      controller: unitName,
                                      decoration: InputDecoration(
                                        labelText: "Birim Adı",
                                        labelStyle:
                                            TextStyle(color: Colors.black87),
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(23, 162, 184, 1),
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        Pattern pattern = r'^([a-zA-Z])';

                                        RegExp regex = new RegExp(pattern);

                                        if (value == null || value.isEmpty) {
                                          return 'Değer giriniz';
                                        }
                                        if (!regex.hasMatch(value)) {
                                          return 'Kelime giriniz';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                  BootstrapCol(
                                    sizes: 'col-6',
                                    child: TextFormField(
                                      controller: unitPhone,
                                      decoration: InputDecoration(
                                        labelText: "Birim Telefon",
                                        labelStyle:
                                            TextStyle(color: Colors.black87),
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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

                                        return null;
                                      },
                                    ),
                                  ),
                                ]),
                                BootstrapRow(height: 80, children: [
                                  BootstrapCol(
                                    sizes: 'col-12',
                                    child: TextFormField(
                                      controller: unitAddress,
                                      decoration: InputDecoration(
                                        labelText: "Birim Adresi",
                                        labelStyle:
                                            TextStyle(color: Colors.black87),
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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

                                        return null;
                                      },
                                    ),
                                  ),
                                ]),
                                BootstrapRow(height: 80, children: [
                                  BootstrapCol(
                                    sizes: 'col-12',
                                    child: TextFormField(
                                      controller: unitImage,
                                      decoration: InputDecoration(
                                        labelText: "Birim Resmi",
                                        labelStyle:
                                            TextStyle(color: Colors.black87),
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                          Object unitObj = {
                                            "name": unitName.text,
                                            "adress": unitAddress.text,
                                            "phone": unitPhone.text,
                                            "ministaryid": ministaryId,
                                            "image_url": unitImage.text
                                          };
                                          final response =
                                              await AdminData.createUnit(
                                                  unitObj);

                                          if (response.statusCode == 200) {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminPage()),
                                                (route) => false);
                                            Alertify(
                                                    alertType:
                                                        AlertifyType.success,
                                                    context: context,
                                                    title: "Başarılı",
                                                    content:
                                                        "Birim Ekleme işlemi başarılı.",
                                                    animationType: AnimationType
                                                        .bottomToTop,
                                                    buttonText: 'Ok',
                                                    isDismissible: true)
                                                .show();
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

// #add  doctor
  showDoctorModal(context) async {
    final formKey = GlobalKey<FormState>();
    final doctorName = TextEditingController();
    final doctorPhone = TextEditingController();
    final doctorAddress = TextEditingController();
    final doctorImage = TextEditingController();

    final storage = new FlutterSecureStorage();
    int ministaryId = 0;
    HealthUnitModel selectedUnitToAddDoctor;

    var key = await storage.read(key: "token");
    var userObj = Jwt.parseJwt(key);
    ministaryId = userObj["ministary_id"];
    List<HealthUnitModel> unitList = [];
    unitList = await AdminData.getUnitsByMinistary(ministaryId);

    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
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
                                          controller: doctorName,
                                          decoration: InputDecoration(
                                            labelText: "Ad-Soyad",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            Pattern pattern = r'^([a-zA-Z])';

                                            RegExp regex = new RegExp(pattern);

                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return 'Kelime giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      BootstrapCol(
                                        sizes: 'col-6',
                                        child: TextFormField(
                                          controller: doctorPhone,
                                          decoration: InputDecoration(
                                            labelText: "Telefon",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ]),
                                    BootstrapRow(height: 80, children: [
                                      BootstrapCol(
                                        sizes: 'col-12',
                                        child: TextFormField(
                                          controller: doctorAddress,
                                          decoration: InputDecoration(
                                            labelText: "Adres",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ]),
                                    BootstrapRow(height: 80, children: [
                                      BootstrapCol(
                                        sizes: 'col-12',
                                        child: TextFormField(
                                          controller: doctorImage,
                                          decoration: InputDecoration(
                                            labelText: "Resim",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ]),
                                    BootstrapCol(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: SizedBox(
                                          width: 300,
                                          height: 50,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Color.fromRGBO(
                                                        23, 162, 184, 1))),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: DropdownButton(
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 10,
                                                ),
                                                value: selectedUnitToAddDoctor,
                                                items: unitList.map(
                                                    (HealthUnitModel value) {
                                                  return new DropdownMenuItem<
                                                      HealthUnitModel>(
                                                    value: value,
                                                    child: new Text(
                                                      value.unitName,
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (val) {
                                                  setState(() =>
                                                      selectedUnitToAddDoctor =
                                                          val);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    BootstrapCol(
                                        sizes: 'col-6',
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromRGBO(
                                                  23, 162, 184, 1),
                                              side: BorderSide(
                                                color: Colors.white,
                                              )),
                                          child: Text("Kaydet"),
                                          onPressed: () async {
                                            if (formKey.currentState
                                                .validate()) {
                                              Object doctorObj = {
                                                "name": doctorName.text,
                                                "phone": doctorPhone.text,
                                                "adress": doctorAddress.text,
                                                "unitid":
                                                    selectedUnitToAddDoctor.id,
                                                "imageurl": doctorImage.text
                                              };

                                              final response =
                                                  await AdminData.createDoctor(
                                                      doctorObj);

                                              if (response.statusCode == 200) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminPage()),
                                                    (route) => false);
                                                Alertify(
                                                        context: context,
                                                        isDismissible: true,
                                                        alertType: AlertifyType
                                                            .success,
                                                        title: 'Başarılı',
                                                        buttonText: 'OK',
                                                        animationType:
                                                            AnimationType
                                                                .bottomToTop,
                                                        content:
                                                            "Doktor Ekleme Başarılı.")
                                                    .show();
                                              }
                                            }
                                          },
                                        )),
                                  ],
                                ),
                              ))
                        ]))),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Row(
              children: [
                widget.openMenu
                    ? Container(
                        child: Row(
                          children: [
                            NavigationRail(
                              selectedLabelTextStyle:
                                  TextStyle(color: Colors.white),
                              backgroundColor: Color.fromRGBO(23, 162, 184, 1),
                              selectedIndex: selectedIndex,
                              onDestinationSelected: (int index) {
                                setState(() {
                                  selectedIndex = index;
                                });

                                print(widget.openMenu);
                              },
                              labelType: NavigationRailLabelType.selected,
                              destinations: [
                                NavigationRailDestination(
                                    icon: Icon(Icons.home),
                                    selectedIcon: Icon(
                                      Icons.home_filled,
                                      color: Colors.white,
                                    ),
                                    label: Text("Anasayfa")),
                                NavigationRailDestination(
                                    icon: FaIcon(FontAwesomeIcons.industry),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.industry,
                                      color: Colors.white,
                                    ),
                                    label: Text("Üreticiler")),
                                NavigationRailDestination(
                                    icon:
                                        FaIcon(FontAwesomeIcons.clinicMedical),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.clinicMedical,
                                      color: Colors.white,
                                    ),
                                    label: Text("Birimler")),
                                NavigationRailDestination(
                                    icon: FaIcon(FontAwesomeIcons.cubes),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.cubes,
                                      color: Colors.white,
                                    ),
                                    label: Text("Stoklar")),
                                NavigationRailDestination(
                                    icon: FaIcon(FontAwesomeIcons.users),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.users,
                                      color: Colors.white,
                                    ),
                                    label: Text("İşlemler")),
                              ],
                            ),
                            selectedWidget()
                          ],
                        ),
                      )
                    : menuDisabled()
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(23, 162, 184, 1)),
                backgroundColor: Colors.white,
              ),
            ),
    );
  }

  //# Menu Active
  Widget selectedWidget() {
    double screenWidth = MediaQuery.of(context).size.width;

    if (selectedIndex == 0 && widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 115,
                  child: DecoratedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(ministaryInfos.imageUrl),
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 80),
                                  child: Text(
                                    ministaryInfos.ministaryCountry,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Ülke İhtiyacı :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        totalNeed.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Son Alım Tarihi :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        ministaryInfos.lastPurchaseDate
                                            .split('T')[0],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Toplam Aşı Sayısı :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        ministaryInfos.totalVaccineCount
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Son Satın Alınan Miktar :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        ministaryInfos.lastPurchasedVaccineCount
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
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
                  ),
                ),
              ),
            )
          ]));
    } else if (selectedIndex == 1 && widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 115,
                  child: DecoratedBox(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: producerList.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          onTap: () {
                            print("tile clicked");
                          },
                          trailing: IconButton(
                              icon: Icon(Icons.delete_forever,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                final response =
                                    await AdminData.deleteProducerMinistary(
                                        producerList[i].id);
                                if (response.statusCode == 200) {
                                  Alertify(
                                          context: context,
                                          isDismissible: true,
                                          alertType: AlertifyType.success,
                                          title: 'Başarılı',
                                          buttonText: 'OK',
                                          animationType:
                                              AnimationType.bottomToTop,
                                          content: "Üretici Silme Başarılı.")
                                      .show();

                                  setState(() {
                                    getData();
                                  });
                                }
                              }),
                          title: Text(producerList[i].producerName,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        );
                      },
                    ),
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
                  ),
                ),
              ),
            )
          ]));
    } else if (selectedIndex == 2 && widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: screenWidth - 115,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DecoratedBox(
                            child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: unitList.length,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  onTap: () {
                                    print("tile clicked");
                                  },
                                  trailing: IconButton(
                                      icon: Icon(Icons.delete_forever,
                                          color: Colors.redAccent),
                                      onPressed: () async {
                                        final response =
                                            await AdminData.deleteUnitById(
                                                unitList[i].id);

                                        if (response.statusCode == 200) {
                                          Alertify(
                                                  context: context,
                                                  isDismissible: true,
                                                  alertType:
                                                      AlertifyType.success,
                                                  title: 'Başarılı',
                                                  buttonText: 'OK',
                                                  animationType:
                                                      AnimationType.bottomToTop,
                                                  content:
                                                      "Birim Silme Başarılı.")
                                              .show();

                                          setState(() {
                                            getData();
                                          });
                                        }
                                      }),
                                  title: Text(unitList[i].unitName,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                );
                              },
                            ),
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
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DecoratedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: reportList.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {
                                  print("tile clicked");
                                },
                                subtitle: Text(
                                  "ihtiyaç : " +
                                      reportList[i].unitNeeds.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.send_sharp,
                                        color: Colors.greenAccent),
                                    onPressed: () async {
                                      Object ministaryObj = {
                                        "name": ministaryInfos.ministaryCountry,
                                        "need": ministaryInfos.ministaryNeeds,
                                        "total":
                                            ministaryInfos.totalVaccineCount -
                                                reportList[i].unitNeeds,
                                        "img": ministaryInfos.imageUrl,
                                        "lastdate":
                                            ministaryInfos.lastPurchaseDate,
                                        "lastcount": ministaryInfos
                                            .lastPurchasedVaccineCount
                                      };
                                      if (this
                                              .ministaryInfos
                                              .totalVaccineCount >=
                                          reportList[i].unitNeeds) {
                                        final response =
                                            await AdminData.deleteReportById(
                                                reportList[i].id);

                                        if (response.statusCode == 200) {
                                          final response = await AdminData
                                              .updateMinistaryById(
                                                  ministaryId, ministaryObj);
                                          if (response.statusCode == 200) {
                                            Alertify(
                                                    context: context,
                                                    isDismissible: true,
                                                    alertType:
                                                        AlertifyType.success,
                                                    title: 'Başarılı',
                                                    buttonText: 'OK',
                                                    animationType: AnimationType
                                                        .bottomToTop,
                                                    content:
                                                        "Teslimat İşlemi Başarılı.")
                                                .show();

                                            setState(() {
                                              getData();
                                            });
                                          }
                                        }
                                      }
                                    }),
                                title: Text(reportList[i].unitName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              );
                            },
                          ),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]));
    } else if (selectedIndex == 3 && widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 115,
                  child: DecoratedBox(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: stockList.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          onTap: () {
                            print("tile clicked");
                          },
                          trailing: IconButton(
                              icon: Icon(Icons.add, color: Colors.greenAccent),
                              onPressed: () {
                                showProducerStockModal(context, stockList[i]);
                              }),
                          title: Text(stockList[i].vaccineName,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          subtitle: Text(
                            "Miktar : " + stockList[i].vaccineCount.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
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
                  ),
                ),
              ),
            )
          ]));
    } else if (selectedIndex == 4 && widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: screenWidth - 115,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DecoratedBox(
                            child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userList.length,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  onTap: () {
                                    print("tile clicked");
                                  },
                                  trailing: IconButton(
                                      icon: Icon(Icons.delete_forever,
                                          color: Colors.redAccent),
                                      onPressed: () async {
                                        final response =
                                            await AdminData.deleteUserById(
                                                userList[i].id);
                                        if (response.statusCode == 200) {
                                          Alertify(
                                                  context: context,
                                                  isDismissible: true,
                                                  alertType:
                                                      AlertifyType.success,
                                                  title: 'Başarılı',
                                                  buttonText: 'OK',
                                                  animationType:
                                                      AnimationType.bottomToTop,
                                                  content:
                                                      "Kullanıcı Silme Başarılı.")
                                              .show();

                                          setState(() {
                                            getData();
                                          });
                                        }
                                      }),
                                  title: Text(userList[i].username,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  subtitle: Text(
                                    userList[i].role,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            ),
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
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DecoratedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: notRegisteredList.length,
                            itemBuilder: (context, i) {
                              return tilesOfList(notRegisteredList, i);
                            },
                          ),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]));
    } else {
      return null;
    }
  }

  tilesOfList(List model, int index) {
    if (model[index] is HealthUnitModel) {
      return ListTile(
          onTap: () {
            print("tile clicked");
          },
          title: Text(model[index].unitName,
              style: TextStyle(color: Colors.white, fontSize: 20)));
    }

    if (model[index] is DoctorModel) {
      return ListTile(
          onTap: () {
            print("tile clicked");
          },
          title: Text(model[index].doctorFullName,
              style: TextStyle(color: Colors.white, fontSize: 20)));
    }
  }

  //# Menu Disabled
  Widget menuDisabled() {
    double screenWidth = MediaQuery.of(context).size.width;
    if (selectedIndex == 0 && !widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 40,
                  child: DecoratedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: screenWidth - 40,
                              height: 50,
                              child: DecoratedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Anasayfa",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(247, 247, 247, 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(ministaryInfos.imageUrl),
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 80),
                                  child: Text(
                                    ministaryInfos.ministaryCountry,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Ülke İhtiyacı :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        totalNeed.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Son Alım Tarihi :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        ministaryInfos.lastPurchaseDate
                                            .split('T')[0],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Toplam Aşı Sayısı :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        ministaryInfos.totalVaccineCount
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Son Satın Alınan Miktar :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        ministaryInfos.lastPurchasedVaccineCount
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
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
                  ),
                ),
              ),
            )
          ]));
    } else if (selectedIndex == 1 && !widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: SizedBox(
                  width: screenWidth - 40,
                  child: DecoratedBox(
                    child: Column(children: [
                      SizedBox(
                        width: screenWidth - 40,
                        height: 50,
                        child: DecoratedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Üreticiler",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                23, 162, 184, 1)),
                                        onPressed: () {
                                          showSelectProducerModal(context);
                                        },
                                        child: Text("Üretici Ekle")),
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(247, 247, 247, 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 170,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: producerList.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(producerList[i].imageUrl),
                                backgroundColor: Colors.transparent,
                              ),
                              onTap: () {
                                print("tile clicked");
                              },
                              trailing: IconButton(
                                  icon: Icon(Icons.delete_forever,
                                      color: Colors.redAccent),
                                  onPressed: () async {
                                    final response =
                                        await AdminData.deleteProducerMinistary(
                                            producerList[i].id);
                                    if (response.statusCode == 200) {
                                      Alertify(
                                              context: context,
                                              isDismissible: true,
                                              alertType: AlertifyType.success,
                                              title: 'Başarılı',
                                              buttonText: 'OK',
                                              animationType:
                                                  AnimationType.bottomToTop,
                                              content:
                                                  "Üretici Silme Başarılı.")
                                          .show();

                                      setState(() {
                                        getData();
                                      });
                                    }
                                  }),
                              title: Text(producerList[i].producerName,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            );
                          },
                        ),
                      ),
                    ]),
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
                  ),
                ),
              ),
            ],
          ));
    } else if (selectedIndex == 2 && !widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: screenWidth - 40,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DecoratedBox(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: screenWidth - 40,
                                  height: 50,
                                  child: DecoratedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          "Birimler",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              247, 247, 247, 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: unitList.length,
                                    itemBuilder: (context, i) {
                                      return ListTile(
                                        onTap: () {
                                          print("tile clicked");
                                        },
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              unitList[i].imageUrl),
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(Icons.delete_forever,
                                                color: Colors.redAccent),
                                            onPressed: () async {
                                              final response = await AdminData
                                                  .deleteUnitById(
                                                      unitList[i].id);

                                              if (response.statusCode == 200) {
                                                Alertify(
                                                        context: context,
                                                        isDismissible: true,
                                                        alertType: AlertifyType
                                                            .success,
                                                        title: 'Başarılı',
                                                        buttonText: 'OK',
                                                        animationType:
                                                            AnimationType
                                                                .bottomToTop,
                                                        content:
                                                            "Birim Silme Başarılı.")
                                                    .show();

                                                setState(() {
                                                  getData();
                                                });
                                              }
                                            }),
                                        title: Text(unitList[i].unitName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20)),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DecoratedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                width: screenWidth - 40,
                                height: 50,
                                child: DecoratedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Raporlar",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(247, 247, 247, 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: reportList.length,
                                  itemBuilder: (context, i) {
                                    return ListTile(
                                      onTap: () {
                                        print("tile clicked");
                                      },
                                      subtitle: Text(
                                        "ihtiyaç : " +
                                            reportList[i].unitNeeds.toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.send_sharp,
                                              color: Colors.greenAccent),
                                          onPressed: () async {
                                            Object ministaryObj = {
                                              "name": ministaryInfos
                                                  .ministaryCountry,
                                              "need": ministaryInfos
                                                  .ministaryNeeds
                                                  .toString(),
                                              "total": (ministaryInfos
                                                          .totalVaccineCount -
                                                      reportList[i].unitNeeds)
                                                  .toString(),
                                              "img": ministaryInfos.imageUrl,
                                              "lastdate": ministaryInfos
                                                  .lastPurchaseDate,
                                              "lastcount": ministaryInfos
                                                  .lastPurchasedVaccineCount
                                                  .toString()
                                            };
                                            if (this
                                                    .ministaryInfos
                                                    .totalVaccineCount >=
                                                reportList[i].unitNeeds) {
                                              final response = await AdminData
                                                  .deleteReportById(
                                                      reportList[i].id);

                                              if (response.statusCode == 200) {
                                                final response = await AdminData
                                                    .updateMinistaryById(
                                                        ministaryId,
                                                        ministaryObj);
                                                if (response.statusCode ==
                                                    200) {
                                                  Alertify(
                                                          context: context,
                                                          isDismissible: true,
                                                          alertType:
                                                              AlertifyType
                                                                  .success,
                                                          title: 'Başarılı',
                                                          buttonText: 'OK',
                                                          animationType:
                                                              AnimationType
                                                                  .bottomToTop,
                                                          content:
                                                              "Teslimat İşlemi Başarılı.")
                                                      .show();

                                                  setState(() {
                                                    getData();
                                                  });
                                                }
                                              }
                                            }
                                          }),
                                      title: Text(reportList[i].unitName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]));
    } else if (selectedIndex == 3 && !widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 40,
                  child: DecoratedBox(
                    child: Column(
                      children: [
                        SizedBox(
                          width: screenWidth - 40,
                          height: 50,
                          child: DecoratedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Stoklar",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromRGBO(
                                                  23, 162, 184, 1)),
                                          onPressed: () {
                                            showStockClaimModal(context);
                                          },
                                          child: Text("Yeni Talep")),
                                    )
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(247, 247, 247, 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 170,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: stockList.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {
                                  print("tile clicked");
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(stockList[i].imageUrl),
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.add,
                                        color: Colors.greenAccent),
                                    onPressed: () {
                                      showProducerStockModal(
                                          context, stockList[i]);
                                    }),
                                title: Text(stockList[i].vaccineName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                subtitle: Text(
                                  "Miktar : " +
                                      stockList[i].vaccineCount.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
                  ),
                ),
              ),
            )
          ]));
    } else if (selectedIndex == 4 && !widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: screenWidth - 40,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DecoratedBox(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: screenWidth - 40,
                                  height: 50,
                                  child: DecoratedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Kullanıcılar",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Color.fromRGBO(23,
                                                                  162, 184, 1)),
                                                  onPressed: () {
                                                    showModal(context);
                                                  },
                                                  child: Text("Birim Ekle")),
                                            )
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              247, 247, 247, 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: userList.length,
                                    itemBuilder: (context, i) {
                                      return ListTile(
                                        onTap: () {
                                          print("tile clicked");
                                        },
                                        trailing: IconButton(
                                            icon: Icon(Icons.delete_forever,
                                                color: Colors.redAccent),
                                            onPressed: () async {
                                              final response = await AdminData
                                                  .deleteUserById(
                                                      userList[i].id);
                                              if (response.statusCode == 200) {
                                                Alertify(
                                                        context: context,
                                                        isDismissible: true,
                                                        alertType: AlertifyType
                                                            .success,
                                                        title: 'Başarılı',
                                                        buttonText: 'OK',
                                                        animationType:
                                                            AnimationType
                                                                .bottomToTop,
                                                        content:
                                                            "Kullanıcı Silme Başarılı.")
                                                    .show();

                                                setState(() {
                                                  getData();
                                                });
                                              }
                                            }),
                                        title: Text(userList[i].username,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20)),
                                        subtitle: Text(
                                          userList[i].role,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DecoratedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                width: screenWidth - 40,
                                height: 50,
                                child: DecoratedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Atama Listesi",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color.fromRGBO(
                                                        23, 162, 184, 1)),
                                                onPressed: () {
                                                  showAddUserModal(context);
                                                },
                                                child: Text("Kullanıcı Ata")),
                                          )
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(247, 247, 247, 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: notRegisteredList.length,
                                  itemBuilder: (context, i) {
                                    return tilesOfListWithImage(
                                        notRegisteredList, i);
                                  },
                                ),
                              ),
                            ],
                          ),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]));
    } else {
      return null;
    }
  }

  showSelectProducerModal(context) async {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
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
                                  "Üretici Ekle",
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
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(23, 162, 184, 1))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: DropdownButton(
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                    value: selectedProducer,
                                    items: this
                                        .notAddedProducerList
                                        .map((ProducerModel value) {
                                      return new DropdownMenuItem<
                                          ProducerModel>(
                                        value: value,
                                        child: new Text(
                                          value.producerName,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(
                                          () => this.selectedProducer = val);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: 100,
                              margin: EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(23, 162, 184, 1)),
                                child: Text("Ekle"),
                                onPressed: () async {
                                  Object producerMinistaryObj = {
                                    "ministaryid": ministaryId,
                                    "producerid": selectedProducer.id
                                  };
                                  print(producerMinistaryObj);

                                  final response =
                                      await AdminData.createProducerMinistary(
                                          producerMinistaryObj);

                                  if (response.statusCode == 200) {
                                    Alertify(
                                            context: context,
                                            isDismissible: true,
                                            alertType: AlertifyType.success,
                                            title: 'Başarılı',
                                            buttonText: 'OK',
                                            animationType:
                                                AnimationType.bottomToTop,
                                            content: "Üretici Ekleme Başarılı.")
                                        .show();

                                    setState(() {
                                      getData();
                                    });
                                  }
                                },
                              ))
                        ]))));
          });
        });
  }

  showAddUserModal(context) async {
    final username = TextEditingController();
    final password = TextEditingController();
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
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
                                  "Kullanıcı Ekle",
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
                          ),
                          BootstrapRow(height: 80, children: [
                            BootstrapCol(
                              sizes: 'col-6',
                              child: TextFormField(
                                controller: username,
                                decoration: InputDecoration(
                                  labelText: "Kullanıcı Adı",
                                  labelStyle: TextStyle(color: Colors.black87),
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
                                      color: Color.fromRGBO(23, 162, 184, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Değer giriniz';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            BootstrapCol(
                              sizes: 'col-6',
                              child: TextFormField(
                                controller: password,
                                decoration: InputDecoration(
                                  labelText: "Parola",
                                  labelStyle: TextStyle(color: Colors.black87),
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
                                      color: Color.fromRGBO(23, 162, 184, 1),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Değer giriniz';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ]),
                          BootstrapRow(height: 80, children: [
                            BootstrapCol(
                              sizes: 'col-12',
                              child: SizedBox(
                                height: 50,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(23, 162, 184, 1))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: DropdownButton(
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                      value: selectedUser,
                                      items: this
                                          .notRegisteredList
                                          .map((Object value) {
                                        return new DropdownMenuItem<Object>(
                                          value: value,
                                          child: new Text(
                                            value is DoctorModel
                                                ? value.doctorFullName
                                                : value is HealthUnitModel
                                                    ? value.unitName
                                                    : null,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() => this.selectedUser = val);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          Container(
                              width: 100,
                              margin: EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(23, 162, 184, 1)),
                                child: Text("Ekle"),
                                onPressed: () async {
                                  if (selectedUser is DoctorModel) {
                                    DoctorModel map = selectedUser;
                                    Object userObj = {
                                      "username": username.text,
                                      "password": password.text,
                                      "role": "doctor",
                                      "ministary_id": null,
                                      "patient_id": null,
                                      "doctor_id": map.id,
                                      "unit_id": null,
                                      "producer_id": null
                                    };

                                    print(userObj);
                                    final response =
                                        await AdminData.createUser(userObj);

                                    if (response.statusCode == 200) {
                                      Alertify(
                                              context: context,
                                              isDismissible: true,
                                              alertType: AlertifyType.success,
                                              title: 'Başarılı',
                                              buttonText: 'OK',
                                              animationType:
                                                  AnimationType.bottomToTop,
                                              content:
                                                  "Kullanıcı Ekleme Başarılı.")
                                          .show();

                                      setState(() {
                                        getData();
                                      });
                                    }
                                  } else {
                                    HealthUnitModel map = selectedUser;
                                    Object userObj = {
                                      "username": username.text,
                                      "password": password.text,
                                      "role": "healthunit",
                                      "ministary_id": null,
                                      "patient_id": null,
                                      "doctor_id": null,
                                      "unit_id": map.id,
                                      "producer_id": null
                                    };
                                    print(userObj);
                                    final response =
                                        await AdminData.createUser(userObj);

                                    if (response.statusCode == 200) {
                                      Alertify(
                                              context: context,
                                              isDismissible: true,
                                              alertType: AlertifyType.success,
                                              title: 'Başarılı',
                                              buttonText: 'OK',
                                              animationType:
                                                  AnimationType.bottomToTop,
                                              content:
                                                  "Kullanıcı Ekleme Başarılı.")
                                          .show();

                                      setState(() {
                                        getData();
                                      });
                                    }
                                  }
                                },
                              ))
                        ]))));
          });
        });
  }

  showStockClaimModal(context) async {
    final vaccineCount = TextEditingController();
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
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
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 20),
                                child: Text(
                                  "Talep Oluştur",
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
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(23, 162, 184, 1))),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Miktarı giriniz'),
                                      controller: vaccineCount,
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
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(23, 162, 184, 1))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: DropdownButton(
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                    value: selectedProducerToClaim,
                                    items: this
                                        .producerList
                                        .map((ProducerModel value) {
                                      return new DropdownMenuItem<
                                          ProducerModel>(
                                        value: value,
                                        child: new Text(
                                          value.producerName,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() =>
                                          this.selectedProducerToClaim = val);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: 100,
                              margin: EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(23, 162, 184, 1)),
                                child: Text("Talep Et"),
                                onPressed: () async {
                                  DateTime today =
                                      DateTime.parse(DateTime.now().toString());
                                  Object claimObj = {
                                    "count": vaccineCount.text,
                                    "date":
                                        today.toIso8601String().split(".")[0],
                                    "producerid": selectedProducerToClaim.id,
                                    "ministaryid": ministaryId,
                                  };
                                  final response =
                                      await AdminData.createClaimStock(
                                          claimObj);

                                  if (response.statusCode == 200) {
                                    Navigator.pop(context);
                                    Alertify(
                                            content:
                                                "Talep Oluşturma Başarılı.",
                                            title: "Başarılı",
                                            animationType:
                                                AnimationType.bottomToTop,
                                            alertType: AlertifyType.success,
                                            buttonText: "OK",
                                            isDismissible: true,
                                            context: context)
                                        .show();
                                  }
                                },
                              )),
                        ]))));
          });
        });
  }

  showProducerStockModal(context, ProducerStockModel stock) async {
    final vaccineCount = TextEditingController();
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
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
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 20),
                                child: Text(
                                  "Aşı Gönder",
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
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(23, 162, 184, 1))),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      controller: vaccineCount,
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
                                    )),
                              ),
                            ),
                          ),
                          Container(
                              width: 100,
                              margin: EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(23, 162, 184, 1)),
                                child: Text("Ekle"),
                                onPressed: () async {
                                  int count = int.parse(vaccineCount.text);
                                  Object stockObj = {
                                    "ministaryid": ministaryId.toString(),
                                    "stockid": stock.stockId.toString(),
                                    "count":
                                        (stock.vaccineCount - count).toString()
                                  };
                                  print(stockObj);

                                  final response =
                                      await AdminData.updateClaimStockById(
                                          stock.id, stockObj);

                                  if (response.statusCode == 200) {
                                    DateTime today = DateTime.parse(
                                        DateTime.now().toString());

                                    Object ministaryObj = {
                                      "name": ministaryInfos.ministaryCountry,
                                      "need": (ministaryInfos.ministaryNeeds -
                                              count)
                                          .toString(),
                                      "total":
                                          (ministaryInfos.totalVaccineCount +
                                                  count)
                                              .toString(),
                                      "img": ministaryInfos.imageUrl,
                                      "lastdate":
                                          today.toIso8601String().split('.')[0],
                                      "lastcount": count.toString()
                                    };
                                    final response =
                                        await AdminData.updateMinistaryById(
                                            ministaryId, ministaryObj);
                                    if (response.statusCode == 200) {
                                      Alertify(
                                              context: context,
                                              isDismissible: true,
                                              alertType: AlertifyType.success,
                                              title: 'Başarılı',
                                              buttonText: 'OK',
                                              animationType:
                                                  AnimationType.bottomToTop,
                                              content: "Aşı Gönderme Başarılı.")
                                          .show();
                                      setState(() {
                                        getData();
                                      });
                                    }
                                  }
                                },
                              ))
                        ]))));
          });
        });
  }

  tilesOfListWithImage(List model, int index) {
    if (model[index] is HealthUnitModel) {
      return ListTile(
          onTap: () {
            print("tile clicked");
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(model[index].imageUrl),
          ),
          title: Text(model[index].unitName,
              style: TextStyle(color: Colors.white, fontSize: 20)));
    }

    if (model[index] is DoctorModel) {
      return ListTile(
          onTap: () {
            print("tile clicked");
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(model[index].imageUrl),
          ),
          title: Text(model[index].doctorFullName,
              style: TextStyle(color: Colors.white, fontSize: 20)));
    }
  }
}

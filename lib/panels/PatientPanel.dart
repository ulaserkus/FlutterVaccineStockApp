import 'package:alertify/alertify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stock_app/data/PatientData.dart';
import 'package:flutter_stock_app/models/AppointmentModel.dart';
import 'package:flutter_stock_app/models/DoctorModel.dart';
import 'package:flutter_stock_app/models/HealthUnitModel.dart';
import 'package:flutter_stock_app/models/PatientTableModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';

// ignore: must_be_immutable
class PatientPanel extends StatefulWidget {
  bool openMenu;
  PatientPanel({this.openMenu});
  @override
  State<StatefulWidget> createState() {
    return PatientPanelState();
  }
}

class PatientPanelState extends State<PatientPanel> {
  int selectedIndex = 0;
  bool loading = false;
  int patientId;
  final storage = new FlutterSecureStorage();
  PatientTableModel patient;
  List<AppointmentModel> appointments = [];
  List<DoctorModel> doctors = [];
  DoctorModel selectedDoctor;
  DateTime selectedDate = DateTime.now();
  List<Object> phaseList = [];
  int priority = 0;
  @override
  void initState() {
    super.initState();
    getPatientId();
  }

  getPatientId() async {
    var key = await storage.read(key: "token");
    var userObj = Jwt.parseJwt(key);
    this.patientId = userObj["patient_id"];
    print(this.patientId);

    getData();
  }

  getData() async {
    patient = await PatientData.getPatientById(this.patientId);
    appointments = await PatientData.getAppointmentsByPatientId(this.patientId);
    doctors = await PatientData.getDoctorsByMinistaryId(patient.ministaryId);
    phaseList = await PatientData.getPhaseStateByPatientId(patientId);

    selectedDoctor = doctors.first;

    if (this.patient.hasCronicPatient && this.patient.patientAge >= 50) {
      this.priority = 1;
    } else {
      if (this.patient.hasCronicPatient && this.patient.patientAge >= 20) {
        this.priority = 2;
      } else {
        this.priority = 3;
      }
    }

    setState(() {
      loading = true;
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
                                    icon: FaIcon(FontAwesomeIcons.book),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.book,
                                      color: Colors.white,
                                    ),
                                    label: Text("Randevu")),
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
                                      NetworkImage(patient.imageUrl),
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 60),
                                  child: Text(
                                    patient.patientFullName.length > 10
                                        ? patient.patientFullName
                                            .substring(0, 9)
                                        : patient.patientFullName,
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
                                          "Yaş :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        patient.patientAge.toString(),
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
                                          "Telefon :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        patient.patientPhone,
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
                                          "Adres :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        patient.patientAddress,
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
                                          "Kronik Hastalık :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Checkbox(
                                          value: patient.hasCronicPatient,
                                          onChanged: null,
                                          activeColor: Colors.white)
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "Aşı Durumu :",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                    Checkbox(
                                        value: patient.hasVaccinated,
                                        onChanged: null,
                                        activeColor: Colors.white)
                                  ],
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
                      itemCount: appointments.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          onTap: () {
                            print("tile clicked");
                          },
                          trailing: Text("Dr." + appointments[i].doctorFullname,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          title: Text(appointments[i].unitName,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          subtitle: Text(
                            "Tarih : " +
                                appointments[i].appointmentDate.split('T')[0] +
                                " " +
                                appointments[i]
                                    .appointmentDate
                                    .split('T')[1]
                                    .split(':00')[0],
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
    } else {
      return null;
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
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(patient.imageUrl),
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
                                    patient.patientFullName.length > 10
                                        ? patient.patientFullName
                                            .substring(0, 9)
                                        : patient.patientFullName,
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
                                          "Yaş :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        patient.patientAge.toString(),
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
                                          "Telefon :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        patient.patientPhone,
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
                                          "Adres :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        patient.patientAddress,
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
                                          "Kronik Hastalık :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Checkbox(
                                          value: patient.hasCronicPatient,
                                          onChanged: null,
                                          activeColor: Colors.white)
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "Aşı Durumu :",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                    Checkbox(
                                        value: patient.hasVaccinated,
                                        onChanged: null,
                                        activeColor: Colors.white)
                                  ],
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
                                      "Randevular",
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
                                          primary:
                                              Color.fromRGBO(23, 162, 184, 1)),
                                      child: Text(
                                        "Randevu Al",
                                      ),
                                      onPressed: () {
                                        showGetAppointmentModal(context);
                                      },
                                    ),
                                  ),
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
                          itemCount: appointments.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              onTap: () {
                                print("tile clicked");
                              },
                              trailing: Text(
                                  "Dr." + appointments[i].doctorFullname,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              title: Text(appointments[i].unitName,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              subtitle: Text(
                                "Tarih : " +
                                    appointments[i]
                                        .appointmentDate
                                        .split('T')[0] +
                                    " " +
                                    appointments[i]
                                        .appointmentDate
                                        .split('T')[1]
                                        .split(':00')[0],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
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
    } else {
      return null;
    }
  }

  showGetAppointmentModal(context) async {
    final dateText = TextEditingController();
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
                                  "Randevu Al",
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
                              child: Column(
                                children: [
                                  BootstrapRow(height: 80, children: [
                                    BootstrapCol(
                                      sizes: 'col-12',
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: SizedBox(
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
                                                value: selectedDoctor,
                                                items: this
                                                    .doctors
                                                    .map((DoctorModel doctor) {
                                                  return DropdownMenuItem(
                                                      value: doctor,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Dr." +
                                                                doctor
                                                                    .doctorFullName,
                                                            textScaleFactor:
                                                                0.8,
                                                          ),
                                                          Text(" "),
                                                          Text(
                                                            doctor.unitName
                                                                .replaceRange(
                                                                    17,
                                                                    doctor
                                                                        .unitName
                                                                        .length,
                                                                    '...'),
                                                            textScaleFactor:
                                                                0.6,
                                                          ),
                                                        ],
                                                      ));
                                                }).toList(),
                                                hint: Text("Doktor Seç"),
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 20,
                                                ),
                                                onChanged: (val) {
                                                  setState(() {
                                                    selectedDoctor = val;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  BootstrapRow(height: 80, children: [
                                    BootstrapCol(
                                      sizes: 'col-12',
                                      child: TextFormField(
                                        controller: dateText,
                                        onTap: () {
                                          DatePicker.showDateTimePicker(context,
                                              showTitleActions: true,
                                              theme: DatePickerTheme(
                                                  backgroundColor:
                                                      Colors.white),
                                              minTime:
                                                  DateTime(2021, 5, 5, 01, 00),
                                              maxTime:
                                                  DateTime(2031, 6, 7, 12, 00),
                                              onChanged: (date) {
                                            print('change $date in time zone ' +
                                                date.timeZoneOffset.inHours
                                                    .toString());
                                          }, onConfirm: (date) {
                                            selectedDate = date;
                                            dateText.text =
                                                date.toString().split('.')[0];
                                          }, locale: LocaleType.tr);

                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);
                                          currentFocus.unfocus();
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Tarih",
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
                                              color: Color.fromRGBO(
                                                  23, 162, 184, 1),
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
                                        child: Text("Randevu Al"),
                                        onPressed: () async {
                                          if (!patient.hasVaccinated &&
                                              phaseList.length == 0) {
                                            Object appObj = {
                                              "doctorid": selectedDoctor.id,
                                              "patientid": patientId,
                                              "date": this
                                                  .selectedDate
                                                  .toIso8601String()
                                                  .split('.')[0],
                                              "priority": this.priority
                                            };
                                            final response = await PatientData
                                                .createAppointment(appObj);
                                            if (response.statusCode == 200) {
                                              Map<String, dynamic> res =
                                                  await PatientData
                                                      .getLastAppointment();
                                              Object phaseObj = {
                                                "phase": 1,
                                                "doctorpatientid": res["Id"]
                                              };

                                              final response = await PatientData
                                                  .createPhaseState(phaseObj);
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
                                                            "Hasta Randevusu Alındı.")
                                                    .show();
                                                setState(() {
                                                  getData();
                                                });
                                              }
                                            }
                                          }
                                        }),
                                  ),
                                ],
                              ))
                        ]))),
              );
            },
          );
        });
  }

  tilesOfListWithImage(List model, int index) {
    if (model[index] is HealthUnitModel) {
      return ListTile(
          onTap: () {
            print("tile clicked");
          },
          trailing: IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () {}),
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
          trailing: IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () {}),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(model[index].imageUrl),
          ),
          title: Text(model[index].doctorFullName,
              style: TextStyle(color: Colors.white, fontSize: 20)));
    }
  }
}

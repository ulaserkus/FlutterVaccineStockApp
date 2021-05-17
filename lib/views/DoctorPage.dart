import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stock_app/panels/DoctorPanel.dart';
import 'package:flutter_stock_app/views/LoginPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  bool openMenu = false;

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        leading: Row(
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 20),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  onTap: () {
                    setState(() {
                      openMenu = !openMenu;
                    });
                  },
                ),
              ),
            ),
            Flexible(
              child: Container(
                  padding: EdgeInsets.only(left: 72),
                  child: FaIcon(FontAwesomeIcons.syringe)),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(23, 162, 184, 1),
        title: Text(
          'Vaccine Stock',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        actions: [
          IconButton(
              icon: FaIcon(FontAwesomeIcons.signOutAlt),
              onPressed: () async {
                await storage.delete(key: "token");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              })
        ],
      ),
      body: SafeArea(
          child: DoctorPanel(
        openMenu: this.openMenu,
      )),
      backgroundColor: Colors.white,
    );
  }
}

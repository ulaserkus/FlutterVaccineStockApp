import 'package:flutter/material.dart';
import 'package:flutter_stock_app/panels/InfoPanel.dart';
import 'package:flutter_stock_app/views/LoginPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoPage extends StatelessWidget {
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
        backgroundColor: Color.fromRGBO(23, 162, 184, 1),
        title: Text(
          'Vaccine Stock',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        actions: [
          IconButton(
              icon: FaIcon(FontAwesomeIcons.signInAlt),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              })
        ],
      ),
      body: SafeArea(child: InfoPanel()),
      backgroundColor: Colors.white,
    );
  }
}

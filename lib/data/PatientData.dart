import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_stock_app/models/AppointmentModel.dart';
import 'package:flutter_stock_app/models/DoctorModel.dart';
import 'package:flutter_stock_app/models/PatientTableModel.dart';
import 'package:http/http.dart' as http;

class PatientData {
  static String path = "http://10.0.2.2:5000";

  //api/patient/${id}
  static Future<PatientTableModel> getPatientById(int id) async {
    final response = await http.get(Uri.parse(path + "/api/patient/$id"));

    if (response.statusCode == 200) {
      return PatientTableModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to load doctor");
    }
  }

  //api/patient/appointment/${id}

  static Future<List<AppointmentModel>> getAppointmentsByPatientId(
      int id) async {
    List<AppointmentModel> appointmentList = [];
    final response =
        await http.get(Uri.parse(path + "/api/patient/appointment/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          appointmentList.add(AppointmentModel.fromJson(map));
        }
      }
      return appointmentList;
    } else {
      throw Exception("failed to load doctor");
    }
  }

  //api/doctor/doctors/${id}
  static Future<List<DoctorModel>> getDoctorsByMinistaryId(int id) async {
    List<DoctorModel> doctorList = [];
    final response =
        await http.get(Uri.parse(path + "/api/doctor/doctors/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          doctorList.add(DoctorModel.fromJson(map));
        }
      }
      return doctorList;
    } else {
      throw Exception("failed to load doctor");
    }
  }

  //api/appointments/phase/${id}
  static Future<List<Object>> getPhaseStateByPatientId(int id) async {
    List<Object> list = [];
    final response =
        await http.get(Uri.parse(path + "/api/doctor/doctors/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          list.add(map);
        }
      }
      return list;
    } else {
      throw Exception("failed to load doctor");
    }
  }

  //api/appointments/create
  static Future<Response> createAppointment(Object obj) async {
    Response response;
    BaseOptions options = new BaseOptions(
      baseUrl: path,
      connectTimeout: 6000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    dio.options.contentType = Headers.acceptHeader;
    dio.options.contentType = Headers.jsonContentType;

    try {
      response =
          await dio.post("/api/appointments/create", data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/appointments/last
  static Future<Object> getLastAppointment() async {
    final response = await http.get(Uri.parse(path + "/api/appointments/last"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("failed to load lastId");
    }
  }

  //api/appointments/createphase
  static Future<Response> createPhaseState(Object obj) async {
    Response response;
    BaseOptions options = new BaseOptions(
      baseUrl: path,
      connectTimeout: 6000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    dio.options.contentType = Headers.acceptHeader;
    dio.options.contentType = Headers.jsonContentType;

    try {
      response = await dio.post("/api/appointments/createphase",
          data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_stock_app/models/DoctorModel.dart';
import 'package:flutter_stock_app/models/HealthUnitModel.dart';
import 'package:flutter_stock_app/models/PatientAppointmentModel.dart';
import 'package:http/http.dart' as http;

class DoctorData {
  static String path = "http://10.0.2.2:5000";

  //api/doctor/${id}
  static Future<DoctorModel> getDoctorById(int id) async {
    final response = await http.get(Uri.parse(path + "/api/doctor/$id"));

    if (response.statusCode == 200) {
      return DoctorModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to load doctor");
    }
  }

  //api/healthunits/doctorunit/${id}
  static Future<HealthUnitModel> getUnitByDoctorId(int id) async {
    final response =
        await http.get(Uri.parse(path + "/api/healthunits/doctorunit/$id"));

    if (response.statusCode == 200) {
      return HealthUnitModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to load doctor");
    }
  }

  //api/appointments/phaseone/${id}
  static Future<List<PatientAppointmentModel>>
      getPhaseOneAppointmentsByDoctorId(int id) async {
    List<PatientAppointmentModel> appointmentList = [];
    final response =
        await http.get(Uri.parse(path + "/api/appointments/phaseone/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          appointmentList.add(PatientAppointmentModel.fromJson(map));
        }
      }

      return appointmentList;
    } else {
      throw Exception("Failed to load appointments");
    }
  }

  //api/appointments/phasetwo/${id}
  static Future<List<PatientAppointmentModel>>
      getPhaseTwoAppointmentsByDoctorId(int id) async {
    List<PatientAppointmentModel> appointmentList = [];
    final response =
        await http.get(Uri.parse(path + "/api/appointments/phasetwo/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          appointmentList.add(PatientAppointmentModel.fromJson(map));
        }
      }

      return appointmentList;
    } else {
      throw Exception("Failed to load appointments");
    }
  }

  //api/appointments/phaseextra/${id}
  static Future<List<PatientAppointmentModel>>
      getPhaseExtraAppointmentsByDoctorId(int id) async {
    List<PatientAppointmentModel> appointmentList = [];
    final response =
        await http.get(Uri.parse(path + "/api/appointments/phaseextra/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          appointmentList.add(PatientAppointmentModel.fromJson(map));
        }
      }

      return appointmentList;
    } else {
      throw Exception("Failed to load appointments");
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

  //api/appointments/delete/${id}
  static Future<http.Response> deletePhaseState(int id) async {
    final response =
        http.delete(Uri.parse(path + "/api/appointments/delete/$id"));

    return response;
  }

  //api/patient/update/${id}
  static Future<Response> updatePatientById(int id, Object object) async {
    BaseOptions options = new BaseOptions(
      baseUrl: path,
      connectTimeout: 6000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    dio.options.contentType = Headers.acceptHeader;
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = dio.patch("/api/patient/update/$id", data: object);

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

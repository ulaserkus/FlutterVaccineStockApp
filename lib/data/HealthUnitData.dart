import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_stock_app/models/DoctorModel.dart';
import 'package:flutter_stock_app/models/HealthUnitModel.dart';
import 'package:flutter_stock_app/models/PatientModel.dart';
import 'package:flutter_stock_app/models/ReportModel.dart';
import 'package:http/http.dart' as http;

class HealthUnitData {
  static String path = "http://10.0.2.2:5000";

  //api/healthunits/unit/${id}

  static Future<HealthUnitModel> getUnitById(int id) async {
    final response =
        await http.get(Uri.parse(path + "/api/healthunits/unit/$id"));

    if (response.statusCode == 200) {
      return HealthUnitModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load unit");
    }
  }

  //api/healthunits/unit/reports/${id}
  static Future<List<ReportModel>> getReportsByUnitId(int id) async {
    List<ReportModel> reports = [];
    final response =
        await http.get(Uri.parse(path + "/api/healthunits/unit/reports/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          reports.add(ReportModel.fromJson(map));
        }
      }

      return reports;
    } else {
      throw Exception("Failed to load unit");
    }
  }

  //api/doctor/unit/${id}
  static Future<List<DoctorModel>> getDoctorsByUnitId(int id) async {
    List<DoctorModel> doctors = [];
    final response = await http.get(Uri.parse(path + "/api/doctor/unit/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          doctors.add(DoctorModel.fromJson(map));
        }
      }

      return doctors;
    } else {
      throw Exception("Failed to load unit");
    }
  }

  //api/patient/patients/${id}
  static Future<List<PatientModel>> getPatientsByUnitId(int id) async {
    List<PatientModel> patients = [];
    final response =
        await http.get(Uri.parse(path + "/api/patient/patients/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          patients.add(PatientModel.fromJson(map));
        }
      }

      return patients;
    } else {
      throw Exception("Failed to load unit");
    }
  }

  //api/healthunits/createreport

  static Future<Response> createReport(Object object) async {
    BaseOptions options = BaseOptions(
      baseUrl: path,
      connectTimeout: 6000,
      receiveTimeout: 300,
    );
    Dio dio = Dio(options);
    dio.options.contentType = Headers.acceptHeader;
    dio.options.contentType = Headers.jsonContentType;

    try {
      Response response = await dio.post("/api/healthunits/createreport",
          data: jsonEncode(object));

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/healthunits/report/delete/${id}

  static Future<http.Response> deleteReportById(int id) async {
    try {
      final response = await http
          .delete(Uri.parse(path + "/api/healthunits/report/delete/$id"));

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/doctor/create
  static Future<Response> createDoctor(Object obj) async {
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
      response = await dio.post("/api/doctor/create", data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/doctor/delete/${id}
  static Future<http.Response> deleteDoctorById(int id) async {
    try {
      final response =
          await http.delete(Uri.parse(path + "/api/doctor/delete/$id"));

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/patient/create
  static Future<Response> createPatient(Object obj) async {
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
      response = await dio.post("/api/patient/create", data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/healthunits/lastpatient
  static Future<Object> getLastPatientId() async {
    final response =
        await http.get(Uri.parse(path + "/api/healthunits/lastpatient"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("failed to load lastId");
    }
  }

  //api/healthunits/createuser
  static Future<Response> createUser(Object obj) async {
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
          await dio.post("/api/healthunits/createuser", data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/patient/delete/${id}
  static Future<http.Response> deletePatientById(int id) async {
    final response = http.delete(Uri.parse(path + "/api/patient/delete/$id"));

    return response;
  }
}

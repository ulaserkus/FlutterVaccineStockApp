import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_stock_app/models/DoctorModel.dart';
import 'package:flutter_stock_app/models/HealthUnitModel.dart';
import 'package:flutter_stock_app/models/MinistaryModel.dart';
import 'package:flutter_stock_app/models/ProducerModel.dart';
import 'package:flutter_stock_app/models/ProducerStockModel.dart';
import 'package:flutter_stock_app/models/ReportModel.dart';
import 'package:flutter_stock_app/models/UserModel.dart';
import 'package:flutter_stock_app/models/WorldStockModel.dart';
import 'package:flutter_stock_app/models/WorldVaccineModel.dart';
import 'package:http/http.dart' as http;

class AdminData {
  static String path = "http://10.0.2.2:5000";

  static Future<List<WorldStockModel>> getPercantagesOfStocks() async {
    List<WorldStockModel> stockList = [];
    final response =
        await http.get(Uri.parse(path + "/api/vaccinestock/count"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];

          stockList.add(WorldStockModel.fromJson(map));
        }
      }

      return stockList;
    } else {
      throw Exception('Failed to load stockList');
    }
  }

  static Future<List<WorldVaccineModel>> getPercantagesOfVaccine() async {
    List<WorldVaccineModel> vaccineList = [];
    final response =
        await http.get(Uri.parse(path + "/api/ministary/percantage/list"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          vaccineList.add(WorldVaccineModel.fromJson(map));
        }
      }
      return vaccineList;
    } else {
      throw Exception("Failed to load vaccineList");
    }
  }

  static Future<http.Response> postUser(Object userObj) async {
    final response =
        await http.post(Uri.parse(path + "/api/user/login"), body: userObj);

    return response;
  }

  //api/ministary/${id}
  static Future<MinistaryModel> getMinistary(int id) async {
    final response = await http.get(Uri.parse(path + "/api/ministary/$id"));

    if (response.statusCode == 200) {
      return MinistaryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ministary not loaded');
    }
  }
  //api/healthunits/report/${id}

  static Future<List<ReportModel>> getReportsByMinistaryId(int id) async {
    List<ReportModel> reportList = [];
    final response =
        await http.get(Uri.parse(path + "/api/healthunits/report/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          reportList.add(ReportModel.fromJson(map));
        }
      }
      return reportList;
    } else {
      throw Exception("Failed to load vaccineList");
    }
  }

  //api/producerministary/producers/${id}

  static Future<List<ProducerModel>> getProducersByMinistary(int id) async {
    List<ProducerModel> producerList = [];
    final response = await http
        .get(Uri.parse(path + "/api/producerministary/producers/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          producerList.add(ProducerModel.fromJson(map));
        }
      }
      return producerList;
    } else {
      throw Exception("Failed to load producers");
    }
  }

  //api/healthunits/${id}
  static Future<List<HealthUnitModel>> getUnitsByMinistary(int id) async {
    List<HealthUnitModel> unitList = [];
    final response = await http.get(Uri.parse(path + "/api/healthunits/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          unitList.add(HealthUnitModel.fromJson(map));
        }
      }
      return unitList;
    } else {
      throw Exception("Failed to load units");
    }
  }

  //api/vaccinestock/ministary/${id}
  static Future<List<ProducerStockModel>> getStockByMinistary(int id) async {
    List<ProducerStockModel> stockList = [];
    final response =
        await http.get(Uri.parse(path + "/api/vaccinestock/ministary/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          stockList.add(ProducerStockModel.fromJson(map));
        }
      }
      return stockList;
    } else {
      throw Exception("Failed to load units");
    }
  }

  //api/user/doctors/${id}
  static Future<List<UserModel>> getDoctorUsersByMinistaryId(int id) async {
    List<UserModel> userList = [];
    final response = await http.get(Uri.parse(path + "/api/user/doctors/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          userList.add(UserModel.fromJson(map));
        }
      }
      return userList;
    } else {
      throw Exception("Failed to load users");
    }
  }

  //api/user/units/${id}

  static Future<List<UserModel>> getUnitUsersByMinistaryId(int id) async {
    List<UserModel> userList = [];
    final response = await http.get(Uri.parse(path + "/api/user/units/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          userList.add(UserModel.fromJson(map));
        }
      }
      return userList;
    } else {
      throw Exception("Failed to load users");
    }
  }

  //api/user/noregistered/units/${id}
  static Future<List<HealthUnitModel>> getNotRegisteredUnitUsersByMinistaryId(
      int id) async {
    List<HealthUnitModel> unitList = [];
    final response =
        await http.get(Uri.parse(path + "/api/user/noregistered/units/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          unitList.add(HealthUnitModel.fromJson(map));
        }
      }
      return unitList;
    } else {
      throw Exception("Failed to load users");
    }
  }

  //api/user/noregistered/doctors/${id}
  static Future<List<DoctorModel>> getNotRegisteredDoctorUsersByMinistaryId(
      int id) async {
    List<DoctorModel> doctorList = [];
    final response =
        await http.get(Uri.parse(path + "/api/user/noregistered/doctors/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          doctorList.add(DoctorModel.fromJson(map));
        }
      }
      return doctorList;
    } else {
      throw Exception("Failed to load users");
    }
  }

  //api/ministary/value/create
  static Future<Response> createMinistary(Object obj) async {
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
          await dio.post("/api/ministary/value/create", data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
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

  //api/ministary/id/last
  static Future<Object> getLastMinistaryId() async {
    final response = await http.get(Uri.parse(path + "/api/ministary/id/last"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("failed to load lastId");
    }
  }

  //api/producer/create
  static Future<Response> createProducer(Object obj) async {
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
      response = await dio.post("/api/producer/create", data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/producer/last/id
  static Future<Object> getLastProducerId() async {
    final response = await http.get(Uri.parse(path + "/api/producer/last/id"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("failed to load lastId");
    }
  }

  //api/producer/${id}
  static Future<List<ProducerModel>> getNotAddedProducers(int id) async {
    List<ProducerModel> producerList = [];
    final response = await http.get(Uri.parse(path + "/api/producer/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          producerList.add(ProducerModel.fromJson(map));
        }
      }
      return producerList;
    } else {
      throw Exception("Failed to load users");
    }
  }

  //api/producerministary/create
  static Future<Response> createProducerMinistary(Object obj) async {
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
      response = await dio.post("/api/producerministary/create",
          data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/producerministary/producer/${id}
  static Future<http.Response> deleteProducerMinistary(int producerId) async {
    final response = http.delete(
        Uri.parse(path + "/api/producerministary/producer/$producerId"));

    return response;
  }

  //api/healthunits/unit/delete/${id}
  static Future<http.Response> deleteUnitById(int id) async {
    final response =
        http.delete(Uri.parse(path + "/api/healthunits/unit/delete/$id"));

    return response;
  }

  //api/healthunits/report/delete/${id}
  static Future<http.Response> deleteReportById(int id) async {
    final response =
        http.delete(Uri.parse(path + "/api/healthunits/report/delete/$id"));

    return response;
  }
  //api/ministary/update/${id}

  static Future<http.Response> updateMinistaryById(
      int id, Object object) async {
    try {
      final response = http.patch(Uri.parse(path + "/api/ministary/update/$id"),
          body: object);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/vaccinestock/updateclaim/${id}

  static Future<http.Response> updateClaimStockById(
      int id, Object object) async {
    try {
      final response = http.patch(
          Uri.parse(path + "/api/vaccinestock/updateclaim/$id"),
          body: object);

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/user/delete/${id}
  static Future<http.Response> deleteUserById(int id) async {
    final response = http.delete(Uri.parse(path + "/api/user/delete/$id"));

    return response;
  }

  //api/vaccinestock/createclaim
  static Future<Response> createClaimStock(Object obj) async {
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
      response = await dio.post("/api/vaccinestock/createclaim",
          data: jsonEncode(obj));
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

  //api/healthunits/create
  static Future<Response> createUnit(Object obj) async {
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
          await dio.post("/api/healthunits/create", data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

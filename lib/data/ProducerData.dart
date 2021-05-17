import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_stock_app/models/ClaimModel.dart';
import 'package:flutter_stock_app/models/MinistaryModel.dart';
import 'package:flutter_stock_app/models/ProducerModel.dart';
import 'package:flutter_stock_app/models/ProducerStockModel.dart';
import 'package:http/http.dart' as http;

class ProducerData {
  static String path = "http://10.0.2.2:5000";
  //api/producer/producer/${id}
  static Future<ProducerModel> getProducerById(int id) async {
    final response =
        await http.get(Uri.parse(path + "/api/producer/producer/$id"));

    if (response.statusCode == 200) {
      return ProducerModel.fromJson(jsonDecode(response.body));
    } else {
      return throw Exception("Failed to load producer");
    }
  }

  //api/vaccinestock/claims/${id}

  static Future<List<ClaimModel>> getClaimsByProducerId(int id) async {
    List<ClaimModel> claimList = [];
    final response =
        await http.get(Uri.parse(path + "/api/vaccinestock/claims/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];

          claimList.add(ClaimModel.fromJson(map));
        }
      }

      return claimList;
    } else {
      throw Exception('Failed to load stockList');
    }
  }

  //api/producer/withstocks/${id}

  static Future<List<ProducerStockModel>> getStocksByProducerId(int id) async {
    List<ProducerStockModel> stockList = [];
    final response =
        await http.get(Uri.parse(path + "/api/producer/withstocks/$id"));

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
      throw Exception('Failed to load stockList');
    }
  }

  //api/vaccinestock/deleteclaim/${id}

  static Future<http.Response> deleteClaimById(int id) async {
    final response =
        http.delete(Uri.parse(path + "/api/vaccinestock/deleteclaim/$id"));

    return response;
  }

  //api/vaccinestock/create
  static Future<Response> createStock(Object obj) async {
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
          await dio.post("/api/vaccinestock/create", data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/vaccinestock/createministarystock
  static Future<Response> createMinistaryStock(Object obj) async {
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
      response = await dio.post("/api/vaccinestock/createministarystock",
          data: jsonEncode(obj));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //api/vaccinestock/update/${id}

  static Future<Response> updateStockById(int id, Object object) async {
    BaseOptions options = new BaseOptions(
      baseUrl: path,
      connectTimeout: 6000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    dio.options.contentType = Headers.acceptHeader;
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = dio.patch("/api/vaccinestock/update/$id", data: object);

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
  //api/ministary/ministaries/${id}

  static Future<List<MinistaryModel>> getMinistaryList(int id) async {
    List<MinistaryModel> ministaryList = [];
    final response =
        await http.get(Uri.parse(path + "/api/ministary/ministaries/$id"));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = jsonDecode(response.body);

      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];

          ministaryList.add(MinistaryModel.fromJson(map));
        }
      }

      return ministaryList;
    } else {
      throw Exception('Failed to load stockList');
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mindtech/app/network/app_env.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/network/app_routing.dart';
import 'package:mindtech/app/network/app_url.dart';
import 'package:mindtech/app/utils/shared_preference_utility.dart';
import 'package:mindtech/main.dart';

class AppHttp {
  Future get({String? url,is_auth = false}) async {
    String baseUrl = AppUrl.BASE_URL;
    Map<String, String> headers = {};
    headers['Content-Type'] = 'application/json';
    Uri requestUrl = Uri.parse("${baseUrl}$url");
    if (is_auth) {
      String username = Environment.apiUsername;
      String password = Environment.apiPassword;
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$username:$password'))}';
      headers['authorization'] = basicAuth;
    } else {
      String barrierToken = await SharedPreferencesUtility.getString('token');
      headers['Authorization'] = 'Bearer $barrierToken';
    }
    dynamic responsejson;
    try {
      final response = await http.get(
        requestUrl,
        headers: headers,
      );
      responsejson = jsonDecode(response.body);
      if(responsejson["status"] == "unauthorized") {
        responsejson = {
          'status': "false",
          'message': 'Contact to admin'
        };
        navigatorKey.currentContext?.go(AppRoutes.login);
      }
    } on SocketException {
      responsejson = {
        'status': "false",
        'message': 'No Internet is available right now'
      };
    } on TimeoutException {
      responsejson = {'status': "false", 'message': 'Server Timeout'};
    } on http.ClientException {
      responsejson = {'status': "false", 'message': 'Bad Request Exception'};
    } on Exception catch (ex) {
      responsejson = {'status': "false", 'message': "Unexpected Error"};
    }

    return responsejson;
  }

  Future post({
    required String url,
    required Map<String, dynamic>? body,
    is_auth = false,
  }) async {
    String baseUrl = AppUrl.BASE_URL;
    Map<String, String> headers = {};
    headers['Content-Type'] = 'application/json';
    Uri requestUrl = Uri.parse("${baseUrl}$url");
    if (is_auth) {
      String username = Environment.apiUsername;
      String password = Environment.apiPassword;
      String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
      headers['authorization'] = basicAuth;
    } else {
      String barrierToken = await SharedPreferencesUtility.getString('token');
      headers['Authorization'] = 'Bearer $barrierToken';
    }
    dynamic responsejson;
    try {
      final response = await http.post(
        requestUrl,
        body: jsonEncode(body),
        headers: headers,
      );
      responsejson = jsonDecode(response.body);
      if(responsejson["status"] == "unauthorized") {
        responsejson = {
          'status': "false",
          'message': 'Contact to admin'
        };
      }
    } on SocketException {
      throw Exception('No Internet is available right now');
    } on TimeoutException {
      throw Exception('Server Timeout');
    } on ClientException {
      throw Exception('Bad Request Exception');
    } on FormatException catch (e) {
      throw Exception('JSON Decoding Error: $e');
    } catch (ex) {
      throw Exception("Unexpected Error: $ex");
    }
    return responsejson;
  }

  Future postImage({
    required String url,
    required Map<String, String> body,
    required Map<String, File?> file,
  }) async {
    String baseUrl = AppUrl.BASE_URL;
    Map<String, String> headers = {};
    headers['Content-Type'] = 'application/json';
    Uri requestUrl = Uri.parse("${baseUrl}$url");
    String barrierToken = await SharedPreferencesUtility.getString('token');
    headers['Authorization'] = 'Bearer $barrierToken';

    dynamic responsejson;
    try {
      var request = http.MultipartRequest('POST', requestUrl);
      if (file.length > 0) {
        file.forEach((key, value) async {
          if(value!=null){
            if (await value.exists()) {
              request.files.add(
                await http.MultipartFile.fromPath(
                  key,
                  value.path,
                ),
              );
            }
          }
        });
      }
      request.headers.addAll(headers);
      request.fields.addAll(body);

      http.StreamedResponse response = await request.send();
      var responseString = await response.stream.bytesToString();
      responsejson = jsonDecode(responseString);
      if(responsejson["status"] == "unauthorized") {
        responsejson = {
          'status': "false",
          'message': 'Contact to admin'
        };
      }
    } on SocketException {
      responsejson = {
        'status': 0,
        'message': 'No Internet is available right now'
      };
    } on TimeoutException {
      responsejson = {'status': 0, 'message': 'Server Timeout'};
    } on http.ClientException {
      responsejson = {'status': 0, 'message': 'Bad Request Exception'};
    } on Exception catch (ex) {
      responsejson = {'status': 0, 'message': "Unexpected Error"};
    }
    return responsejson;
  }

  Future deleteApiResponse(String url,{is_auth = false}) async {
    String baseUrl = AppUrl.BASE_URL;
    Map<String, String> headers = {};
    headers['Content-Type'] = 'application/json';
    Uri requestUrl = Uri.parse("${baseUrl}$url");
    if (is_auth) {
      String username = Environment.apiUsername;
      String password = Environment.apiPassword;
      String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
      headers['authorization'] = basicAuth;
    } else {
      String barrierToken = await SharedPreferencesUtility.getString('token');
      headers['Authorization'] = 'Bearer $barrierToken';
    }

    dynamic responsejson;
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
      responsejson = jsonDecode(response.body);
      if(responsejson["status"] == "unauthorized") {
        responsejson = {
          'status': "false",
          'message': 'Contact to admin'
        };
        SharedPreferencesUtility.setBool("IS_FIRST_SCREEN", true);
      }
    } on SocketException {
      responsejson = {
        'status': false,
        'data': 'No Internet is available right now'
      };
    } on TimeoutException {
      responsejson = {'status': false, 'msg': 'Server Timeout'};
    } on http.ClientException {
      responsejson = {'status': false, 'msg': 'Bad Request Exception'};
    } on Exception catch (ex) {
      responsejson = {'status': false, 'msg': "Unexpected Error"};
    }
    return responsejson;
  }
}

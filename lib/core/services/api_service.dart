import 'dart:convert';
import 'dart:io';

import 'package:e_commerce/core/exceptions/app_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class APIService {
  getAPI({
    required String url,
    Map<String, String>? mHeaders,
    bool isLoginRegister = false,
  }) async {
    Uri uri = Uri.parse(url);

    if(!isLoginRegister){
      mHeaders ??= {};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(AppConstants.prefUserToken) ?? "";
      mHeaders["Authorization"] = "Bearer $token";
    }


    try {
      var response = await http.get(
          uri,
          headers: mHeaders
      );
      return returnResponse(response);
    } on SocketException catch (e) {
      throw NoInternetException(msg: e.toString());
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> postAPI({
    required String url,
    Map<String, dynamic>? mBody,
    Map<String, String>? mHeaders,
    bool isLoginRegister = false,
  }) async {
    Uri uri = Uri.parse(url);

    if(!isLoginRegister){
      mHeaders ??= {};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(AppConstants.prefUserToken) ?? "";
      mHeaders["Authorization"] = "Bearer $token";
    }

    try {
      var response = await http.post(
          uri,
          body: mBody != null ? jsonEncode(mBody) : null,
          headers: mHeaders
      );
      return returnResponse(response);
    } on SocketException catch (e) {
      throw NoInternetException(msg: e.toString());
    } catch (e) {
      print(e);
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          print("Success");
          var data = jsonDecode(response.body);
          return data;
        }

      case 400:
        {
          throw BadRequestException(
            msg: "with status code ${response.statusCode}",
          );
        }

      case 401:
        {
          throw UnauthorizedException(
            msg: "with status code ${response.statusCode}",
          );
        }

      case 404:
        {
          throw NotFoundException(
            msg: "with status code ${response.statusCode}",
          );
        }

      case 500:
      default:
        {
          throw ServerException(msg: "with status code ${response.statusCode}");
        }
    }
  }
}
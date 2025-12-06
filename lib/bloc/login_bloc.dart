import 'dart:convert';
import 'package:responsi2mobile_paket3_h1d023044/helpers/api.dart';
import 'package:responsi2mobile_paket3_h1d023044/helpers/api_url.dart';
import 'package:responsi2mobile_paket3_h1d023044/model/login.dart';

class LoginBloc {
static Future<Login> login({String? email, String? password}) async {
String apiUrl = ApiUrl.login;
var body = {"email": email, "password": password};
var response = await Api().post(apiUrl, body);
var jsonObj = json.decode(response.body);
return Login.fromJson(jsonObj);
}
}
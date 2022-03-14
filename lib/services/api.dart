import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Network{
  final String _url = 'https://apihml.drcash.com.br/api/v1';
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var local = localStorage.getString('token');
    String? tokenReceived = localStorage.getString('token');
    token = jsonDecode(tokenReceived!);
  }

  authData(data, apiUrl) async {
    String? fullUrl = _url + apiUrl;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  getData(apiUrl) async {
    String? fullUrl = _url + apiUrl;
    log("get: $fullUrl");
    await _getToken();
    return await http.get(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Connection' : 'keep-alive',
    'Authorization' : 'Bearer $token'
  };
}
import 'dart:convert';
import 'dart:developer';
import 'package:dr_cash_clinics/models/clinic.dart';
import 'package:flutter/cupertino.dart';
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

  Future<List<Clinic>?> getClinics(String controller, apiUrl) async {
    Uri? fullUrl = Uri.parse(_url + apiUrl);
    var newURI;

    var data;
    if (controller.length < 2){
      newURI = fullUrl;
    }else if(controller.length == 2){
      data = {'state': controller};
      newURI = fullUrl.replace(queryParameters: data);
    }else if(controller.length > 2 ){
      data = {'city': controller};
      newURI = fullUrl.replace(queryParameters: data);
    }

    await _getToken();
    final response = await http.get(
        newURI,
        headers: _setHeaders()
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)['data'] as List)
          .map((json) => Clinic.fromJson(json))
          .toList();
    } else {
      return null;
    }
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Connection' : 'keep-alive',
    'Authorization' : 'Bearer $token'
  };
}
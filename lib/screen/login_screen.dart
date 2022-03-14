import 'dart:convert';

import 'package:dr_cash_clinics/screen/home_screen.dart';
import 'package:dr_cash_clinics/screen/test_screen.dart';
import 'package:dr_cash_clinics/services/api.dart';
import 'package:dr_cash_clinics/utils/dialogs.dart';
import 'package:dr_cash_clinics/utils/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static var tag = "/SignIn";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool? rememberMe = false;
  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();

  GlobalKey<State> _keyLoader = GlobalKey<State>();

  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  serviceEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }
  }

  permissionGranted() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  getLocationData() async {
    _locationData = await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    serviceEnabled();
    permissionGranted();
    getLocationData();
    getLocation();
  }

  getLocation() {
    print('aqui');
    // var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // String yourCityName = address.first.locality;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Observer(
            builder: (_) => Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),
                  Image.asset("assets/images/logoblue.png"),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // formHeading("Login"),
                      // formSubHeadingForm(t1_lbl_sign_up),
                    ],
                  ),
                  SizedBox(height: 50),
                  editTextStyle("E-mail",
                      isPassword: false, controller: emailCont),
                  SizedBox(height: 16),
                  editTextStyle("Senha",
                      isPassword: true, controller: passwordCont),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: CheckboxListTile(
                      title: text("Lembrar-me", textColor: Color(0xFF000000)),
                      value: rememberMe,
                      onChanged: (newValue) {
                        rememberMe = newValue;
                        setState(() {});
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.fromLTRB(40, 16, 40, 16),
                    child: MaterialButton(
                      height: 60,
                      minWidth: double.infinity,
                      child: text("Entrar",
                          fontSize: 18.0,
                          textColor: Colors.white,
                          fontFamily: 'Medium'),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      color: Color(0XFF09efb1),
                      onPressed: () => {_login()},
                    ),
                  ),
                  SizedBox(height: 24),
                  // text(t1_lbl_forgot_password, textColor: appStore.textPrimaryColor, fontFamily: fontMedium)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String erro) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ops!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(erro),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _login() async {
    Dialogs.showLoadingDialog(context, _keyLoader, "Por favor, aguarde!");
    var data = {'email': emailCont.text, 'password': passwordCont.text};
    var res = await Network().authData(data, '/identity/token');
    var body = json.decode(res.body);

    if (body['access_token'] != null) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['access_token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.of(this.context, rootNavigator: true).pop();

      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    } else {
      _showMyDialog("Usuário ou senha incorretos.");
    }
    Navigator.of(this.context, rootNavigator: true).pop();
  }
}

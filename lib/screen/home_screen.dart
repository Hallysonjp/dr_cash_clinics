import 'dart:convert';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_cash_clinics/models/clinic.dart';
import 'package:dr_cash_clinics/services/api.dart';
import 'package:dr_cash_clinics/utils/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Clinic>? listClinics = null;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getClinics();
  }

  Future<List<Clinic>> _getClinics() async {
    await Future.delayed(Duration(seconds: 3));
    Network().getData("/clinics/public").then((response) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> data = map["data"];
        listClinics = data.map((model) => Clinic.fromJson(model)).toList();
      });
    });
    setState(() {
      isLoading = false;
    });
    return listClinics!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0XFF09efb1),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          color: Color(0XFF09efb1),
          child: Row(
            children: <Widget>[
              Text(
                "Listagem de clínicas",
                style: TextStyle(),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildContainer(),
    );
  }

  buildContainer() {
    return listClinics!.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: listClinics!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: T1ListItem(listClinics![index], index),
                  onTap: () => {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CustomDialog(model: listClinics![index]),
                        )
                      });
            });
  }
}

class T1ListItem extends StatelessWidget {
  late Clinic model;
  late int pos;

  T1ListItem(Clinic model, int pos) {
    this.model = model;
    this.pos = pos;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Container(
          decoration: boxDecoration(
              bgColor: Color(0XFFF1F1F1), radius: 10, showShadow: true),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: text(model.tradingName,
                                          textColor: Color(0xFF000000),
                                          fontFamily: 'Bold',
                                          fontSize: 18.0,
                                          maxLine: 2),
                                    ),
                                  ],
                                ),
                                text(model.clinicType,
                                    fontSize: 12.0,
                                    textColor: Color(0xFF000000),
                                    fontFamily: 'Medium'),
                                text(model.city,
                                    textColor: Color(0xFF333333),
                                    fontSize: 14.0),
                              ],
                            ),
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ],
                ),
              ),
              Container(
                width: 4,
                height: 35,
                margin: EdgeInsets.only(top: 16),
                color: pos % 2 == 0 ? Color(0xFF000000) : Color(0XFF09efb1),
              )
            ],
          ),
        ));
  }
}

class CustomDialog extends StatefulWidget {
  final Clinic? model;

  const CustomDialog({Key? key, this.model}) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, widget.model!),
    );
  }
}

dialogContent(BuildContext context, Clinic model) {
  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(top: 10, right: 10),
              alignment: Alignment.centerRight,
              child: Icon(Icons.close, color: Color(0XFF09efb1)),
            ),
          ),
          Image.asset('assets/images/logoblue.png', width: 95, height: 95),
          Container(
            height: 130,
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Expanded(
              child: text(model.tradingName,
                  textColor: Colors.green,
                  fontFamily: 'Bold',
                  fontSize: 24.0,
                  maxLine: 3,
                  isCentered: true),
            ),
          ),
          text(model.clinicType,
              textColor: Colors.green, fontFamily: 'Bold', fontSize: 14.0),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: text(model.city! + " - " + model.state!,
                textColor: Colors.blue,
                fontSize: 14.0,
                maxLine: 2,
                isCentered: true),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              child: Text(model.phoneNumber!, style: TextStyle(fontSize: 14)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0XFF09efb1)),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ))),
              onPressed: () => launch('tel:' + model.phoneNumber!),
            ),
          ),
        ],
      ));
}

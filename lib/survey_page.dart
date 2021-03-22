import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saving_state_radio/blank_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SurveyPage extends StatefulWidget {
  final String jsonSF; //variable dari page pertama

  const SurveyPage({Key key, this.jsonSF}) : super(key: key);
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<RadioGroupSFValue> _surveySharedPreferences; //List yg di simpan ke shared preference

  var jsonValue;
  int _radioGroupValue ; //nah ini variable yg dipakai untuk set otomatis ke radio button

  addToSF(String jsonValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('valueSurvey', jsonValue);
  }

  removeSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('valueSurvey');
  }

  final List<RadioGroup> _surveyList = [
    RadioGroup(index: 0, text: "4"),
    RadioGroup(index: 1, text: "3"),
    RadioGroup(index: 2, text: "2"),
    RadioGroup(index: 3, text: "1"),
  ];

  final saranController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String jsonSF =  widget.jsonSF.toString(); //ambil variable yg di umpan dari page 1 dimasukkan ke string dulu
    if(jsonSF != ''){ //jika ada sf yg disimpan
      jsonValue = jsonDecode(jsonSF); //di sini decode string nya menjadi json biar bisa di proses
      print(jsonValue); //debugging isi json
      int pertanyaanKe = 0; //nah ini pertanyaan ke berapa, bisa dilooping/increment jika pertanyaannya banyak
      _radioGroupValue = jsonValue[pertanyaanKe]['index']; //ini ambil index radio button yg disimpan di sf, untuk otomatis select radiobutton
      saranController.text = jsonValue[pertanyaanKe]['saran']; //otomatis isi kritik dan saran
    }else{
      _radioGroupValue = 0;
      saranController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Radio State"),
      ),
      body: Container(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Manfaat program ini terhadap kebutuhan perusahaan"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _surveyList
                  .map((surveyText) => RadioListTile(
                        title: Text(surveyText.text),
                        value: surveyText.index,
                        groupValue: _radioGroupValue, //disini untuk set otomatis radiobutton yg dipilih
                        controlAffinity: ListTileControlAffinity.trailing,
                        dense: true,
                        selected: true, //wajib true select nya
                        onChanged: (value) {
                          setState(() {
                            _radioGroupValue = value;
                          });
                        },
                      ))
                  .toList(),
            ),
            Container(
              margin: EdgeInsets.only(top: 6, right: 10.0, left: 10.0),
              height: 40,
              child: TextFormField(
                controller: saranController,
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 14.0, color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  //here your padding
                  hintText: 'Komentar dan saran',
                  prefixText: ' ',
                  //when focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  //when enable
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                onChanged: (text) {
                  setState(() {

                  });
                },
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                child: MaterialButton(
                    onPressed: () {
                      removeSF(); //hapus dulu (opsional)
                      _surveySharedPreferences = [RadioGroupSFValue(index: _radioGroupValue, saran: saranController.text)]; //iterasi ke class model baru di simpan, biar rapih dan mengurangi boiler plate pada codemu
                      addToSF(jsonEncode(_surveySharedPreferences)); //simpan ke shared preference

                      //intent
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BlankPage())); //blankpage diasumsikan pindah halaman survey selanjutnya
                    },
                    child: Text('Selanjutnya'),
                    color: Colors.green,
                    textColor: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RadioGroup {
  final int index;
  final String text;

  RadioGroup({this.index, this.text});
}

//model class yg digunakan untuk menyimpan value radiobutton yg disimpan
class RadioGroupSFValue {
  int index;
  String saran;

  RadioGroupSFValue({this.index, this.saran});

  RadioGroupSFValue.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    saran = json['saran'];
  }

  RadioGroupSFValue.toJson(Map<String, dynamic> json) {
    index = json['index'];
    saran = json['saran'];
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'saran': saran,
    };
  }
}

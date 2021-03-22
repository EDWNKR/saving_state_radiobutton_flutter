import 'package:flutter/material.dart';
import 'package:saving_state_radio/survey_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saving State Radio',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Future<String> getValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('valueSurvey') ?? '';
  return stringValue;
}

removeSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('valueSurvey', '');
}

class _HomeState extends State<Home> {
  var passValue; //variable yg digunakan untuk passing ke page survey

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValuesSF().then((value) {
      setState(() {
        passValue = value; //ambil sharedpreference masukkan ke passvalue
      });
    });
  }

  void refreshText(){
    getValuesSF().then((value) {
      setState(() {
        passValue = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Container(
                child: Text("Shared Preference Value : \n" + passValue),
              )),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: MaterialButton(
                    onPressed: () {
                      //intent
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SurveyPage(jsonSF: passValue))); //pindah page survey dengan mengirim value sharedpreference
                    },
                    child: Text('Survey'),
                    color: Colors.green,
                    textColor: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: MaterialButton(
                    onPressed: () {
                      refreshText();
                    },
                    child: Text('GET Shared Preferences'),
                    color: Colors.green,
                    textColor: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: MaterialButton(
                    onPressed: () {
                      removeSF();
                      refreshText();
                    },
                    child: Text('Remove Shared Preferences'),
                    color: Colors.green,
                    textColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

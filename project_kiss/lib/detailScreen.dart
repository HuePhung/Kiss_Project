import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final appBarTitle;
  final Ingredient ingredient;

  DetailScreen(
      {Key key, @required this.appBarTitle, @required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.grey[700],
      ),
      //TODO: wrap with container for backgroundcolor
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      //height: MediaQuery.of(context).size.height * 0.1,
                      //width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        ingredient.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      //height: MediaQuery.of(context).size.height * 0.7,
                      // width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20.0),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.top,
                        children: [
                          TableRow(
                            children: [
                              Text("Description"),
                              Text(ingredient.desc != ""
                                  ? ingredient.desc
                                  : "No description found"),
                            ],
                          ),
                          TableRow(
                            children: [
                              Divider(
                                color: Colors.grey[600],
                                height: 15,
                              ),
                              Divider(
                                color: Colors.grey[600],
                                height: 15,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text("Function"),
                              Text(ingredient.function),
                            ],
                          ),
                          TableRow(
                            children: [
                              Divider(
                                color: Colors.grey[600],
                                height: 15,
                              ),
                              Divider(
                                color: Colors.grey[600],
                                height: 15,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text("Allergic"),
                              Container(
                                child: Column(
                                  children: [
                                    CheckBoxWid(ingredient),
                                    Text(
                                      "Click this button if you are allergic to this substance",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //  height: MediaQuery.of(context).size.height * 0.1,
                      // width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 100, right: 100),
                      child: ElevatedButton(
                        child: Row(children: <Widget>[
                          Icon(Icons.search),
                          Text("Web search")
                        ]),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          _launchURL();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _launchURL() async {
    var url =
        'https://www.google.com/search?q=${ingredient.name.toLowerCase()}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CheckBoxWid extends StatefulWidget {
  final Ingredient ingredient;
  CheckBoxWid(this.ingredient);
  @override
  _CheckBoxState createState() => _CheckBoxState(ingredient);
}

//names of the allergy items are stored in a shared preferences list.
class _CheckBoxState extends State<CheckBoxWid> {
  Ingredient ingredient;
  bool allergyTest = false;
  List<String> allergyNames = [];

  SharedPreferences prefs;
  _CheckBoxState(this.ingredient);
  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Checkbox(
        value: ingredient.isAllergic,
        onChanged: (value) {
          allergyNames = prefs.getStringList("allergyList");
          setState(() {
            if (value) {
              if (!allergyNames.contains(ingredient.name)) {
                allergyNames.add(ingredient.name);
              }
            } else {
              allergyNames.remove(ingredient.name);
            }
            ingredient.isAllergic = value;
          });
          prefs.setStringList("allergyList", allergyNames);
        },
      ),
    );
  }
  /*@override
  Widget build(BuildContext context) => FutureBuilder(
      future: ingredient.getAllergyStatus(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          allergyTest = snapshot.data;
          //SharedPreferences prefs = snapshot.data;
        }
        return Center(
          child: Checkbox(
            value: allergyTest,
            onChanged: (value) {
              setState((){
                if(value) {
                  ingredient.setAllergy(value);
                  allergyNames.add(ingredient.name);
                }
                else {
                  ingredient.isAllergic = value;
                  ingredient.removeAllergyFromPrefs();
                  allergyNames.remove(ingredient.name);
                }
                prefs.setStringList("allergyList", allergyNames);
              });
            },
          ),
        );
      });*/
}

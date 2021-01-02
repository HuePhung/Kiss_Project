import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_final/detailScreen.dart';
import 'package:test_final/search/ingredient.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String appBarTitle;
  final String imagePath;
  final List<Ingredient> ingredients;
  const DisplayPictureScreen(
      {Key key,
        @required this.appBarTitle,
        @required this.imagePath,
        @required this.ingredients,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle), backgroundColor: Colors.black),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical /*, padding: EdgeInsets.all(20.0)*/,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ScanName(imagePath),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Image.file(
                    File(imagePath),
                    width: 250,
                    height: 250,
                  )),
              Text(
                "Ingredients",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: DataTable(
                    columns: [
                      DataColumn(label: Text("Name")),
                      //DataColumn(label: Text("Einstufung")),
                    ],
                    rows: ingredients
                        .map((ingredient) => DataRow(cells: [
                      DataCell(
                        Text(ingredient.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                appBarTitle: "Ingredient",
                                ingredient: ingredient,
                              ),
                            ),
                          );
                        },
                      ),
                      //DataCell(Text(ingredient.desc))
                    ]))
                        .toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ScanName extends StatefulWidget{
  final String imagePath;
  ScanName(this.imagePath);
  @override
  State<StatefulWidget> createState() {
    return ScanNameState(imagePath);
  }
}
class ScanNameState extends State<ScanName>{
  ScanNameState(this.imagePath);
  String imagePath;
  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = "unnamed scan";
  int scanIndex = 0;
  String num = "0";
  Future<SharedPreferences> _prefs;
  @override
  void initState() {
    super.initState();
    _prefs = initPrefs();
  }
  Future<SharedPreferences> initPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> imagePathList = prefs.getStringList("imagePathList");
    num = imagePath.substring(imagePath.length - 9, imagePath.length - 4);
    String date = imagePath.substring(imagePath.length - 19, imagePath.length - 13)+imagePath.substring(imagePath.length - 11, imagePath.length - 9);
    String name = prefs.getString("Scan$num");
    if(name != null)
      initialText = name;
    else{
      initialText = "$date";
      //prefs.setString("Scan$scanIndex", initialText);
    }

    //this is some hard as spaghetti code btw. it would be much better if we had the index as payload for this widget instead of going through all the scans.
    /*scanIndex = imagePathList.indexOf(imagePath);
    //String name = prefs.getString("Scan$scanIndex");
    if(name != null)
      initialText = name;
    else{
      initialText = "Scan $scanIndex";
      //prefs.setString("Scan$scanIndex", initialText);
    }*/

    _editingController = TextEditingController(text: initialText);
    _editingController.selection = new TextSelection(
      baseOffset: 0,
      extentOffset: initialText.length,
    );
    return prefs;
  }
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context)=> FutureBuilder(
    future: _prefs,
      builder: (context, snapshot){
        return _editTitleTextField();
      });

  Widget _editTitleTextField(){
    if (_isEditingText)
        return Center(
        child: TextField(
          onSubmitted: (newValue) async{
            SharedPreferences prefs = await _prefs;
            setState((){
              initialText = newValue;

              prefs.setString('Scan$num', newValue);
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _editingController,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    else {
      return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          initialText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
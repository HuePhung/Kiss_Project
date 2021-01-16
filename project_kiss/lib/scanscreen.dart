import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_final/detailScreen.dart';
import 'package:test_final/search/ingredient.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String appBarTitle;
  final String imagePath;
  final List<Ingredient> ingredients;
  const DisplayPictureScreen({
    Key key,
    @required this.appBarTitle,
    @required this.imagePath,
    @required this.ingredients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fullDate =
        imagePath.substring(imagePath.length - 19, imagePath.length - 9);
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar:
          AppBar(title: Text(appBarTitle), backgroundColor: Colors.grey[800]),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: ScanName(imagePath),
              margin: EdgeInsets.all(15),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(imagePath),
                  width: 140,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Text(
                fullDate,
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: 10,
                left: 20,
              ),
              child: Text(
                "Ingredients",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[300],
                ),
              ),
            ),
            ListWid(ingredients),
          ],
        ),
      ),
    );
  }
}

class ListWid extends StatefulWidget {
  final List ingredients;
  ListWid(this.ingredients);
  @override
  State<StatefulWidget> createState() {
    return ListState(ingredients);
  }
}

class ListState extends State<ListWid> {

  final List ingredients;
  ListState(this.ingredients);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        10,
        20.0,
        10,
        20,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    appBarTitle: "Ingredient",
                    ingredient: ingredients[index],
                  ),
                ),
              ).then((value) => setState(
                    () => FocusScope.of(context).unfocus(),
              ));
            },
            child: Card(
              color: ingredients[index].isAllergic
                  ? const Color(0xff9B3535)
                  : Colors.grey[700],
              elevation: 5.0,
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 5,
                        right: 15,
                      ),
                      child: Text(
                        ingredients[index].name,
                        style: TextStyle(color: Colors.grey[50]),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 5,
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.grey[50],
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}






class ScanName extends StatefulWidget {
  final String imagePath;
  ScanName(this.imagePath);
  @override
  State<StatefulWidget> createState() {
    return ScanNameState(imagePath);
  }
}

class ScanNameState extends State<ScanName> {
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

  Future<SharedPreferences> initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> imagePathList = prefs.getStringList("imagePathList");
    num = imagePath.substring(imagePath.length - 9, imagePath.length - 4);
    String date =
        imagePath.substring(imagePath.length - 19, imagePath.length - 13) +
            imagePath.substring(imagePath.length - 11, imagePath.length - 9);
    String name = prefs.getString("Scan$num");
    if (name != null)
      initialText = name;
    else {
      initialText = "Scan from $date";
      //prefs.setString("Scan$scanIndex", initialText);
    }

    //this is some hard as spaghetti code btw. it would be much better if we had the index as payload for this widget instead of going through all the scans.
    /*scanIndex = imagePathList.indexOf(imagePath);
    //String name = prefs.getString("Scan$scanIndex");
    if(name != null)
      initialText = name;
    else {
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
  Widget build(BuildContext context) => FutureBuilder(
      future: _prefs,
      builder: (context, snapshot) {
        return _editTitleTextField();
      });

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(
              5.0)), //TODO: color search box while typing (maybe use TextFormField)
          color: Colors.grey[700],
        ),
        child: TextField(
          controller: _editingController,
          autofocus: true,
          onSubmitted: (newValue) async {
            SharedPreferences prefs = await _prefs;
            setState(() {
              initialText = newValue;

              prefs.setString('Scan$num', newValue);
              _isEditingText = false;
            });
          },
          style: TextStyle(color: Colors.grey[50]),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[50]),
            suffixIcon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      );
    else {
      return Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isEditingText = true;
                  });
                },
                child: Text(
                  initialText,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isEditingText = true;
                });
              },
            )
          ],
        ),
      );
    }
  }
}

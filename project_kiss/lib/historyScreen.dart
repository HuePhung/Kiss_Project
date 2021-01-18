import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:path/path.dart' as p;
import 'package:test_final/scanscreen.dart';
import 'package:test_final/api/firebase_text_api.dart'; // vorher -> 'package:test_final/api/firebase_ml_api.dart', gibt Fehler @TODO abklären
import 'package:test_final/search/fast_levenshtein.dart';

String imagePath = "";
List<String> imagePathList = [];

Future<void> main() async {
  String temp = await getStringValuesSF();
  if (temp == null)
    imagePath = "";
  else if (temp != null) imagePath = temp;

  print("yeeeeeeeeeeeeeeeeeeeeeeeeees " + temp);
}

Future<String> getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Return String

  String stringValue = prefs.getString("testImagePath");
  return stringValue;
}

Future<String> getStringValueFromListSF(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> prefList = prefs.getStringList("imagePathList");

  // prefList = prefList.reversed.toList();
  String path;

  if (prefList != null) {
    path = prefList[index];
  }

  return path;
}

Future<List<String>> getStringListSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> prefList = prefs.getStringList("imagePathList");
  //prefList = prefList.reversed.toList();
  imagePathList = prefList;

  return prefList;
}

Future<List<String>> getImagePathList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> prefList = prefs.getStringList("imagePathList");
  // prefList = prefList.reversed.toList();

  //prefList.forEach((element) {print(element);});
  //debugPrint("what up nigga");

  //if(prefList == null){
  //  return [];
  //} else {
  return prefList;
  //}
}

Future<SharedPreferences> getPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  debugPrint("getting prefs");
  return prefs;
}

Future<List<Ingredient>> getIngredientsOfProduct(String key) async {
  List<Ingredient> ingredients = [];

  SharedPreferences prefs = await SharedPreferences.getInstance();

  debugPrint(prefs.getString(key));

  json
      .decode(prefs.getString(key))
      .forEach((map) => ingredients.add(new Ingredient.fromJson(map)));

  if (ingredients.isNotEmpty)
    return ingredients;
  else
    return [];
}

Future<List<Ingredient>> checkAllergies(List<Ingredient> ingredients) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> allergies = prefs.getStringList("allergyList");

  if (allergies.isEmpty)
    return ingredients;
  else {
    allergies.forEach((allergy) {
      ingredients.forEach((ingredient) {
        if (ingredient.name == allergy) {
          ingredient.isAllergic = true;
        }
      });
    });

    return ingredients;
  }
}

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryScreen();
  }
}

class _HistoryScreen extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin<HistoryScreen> {
  //List items = getDummyList();
  List<String> pathList = ["0"];

  //Future<List<String>> _pathList;
  List<Ingredient> ingredients;
  Future<SharedPreferences> _prefs;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    debugPrint("in initState");
    //getStringListSF();
    _prefs = getPrefs();
    ingredients = [];
  }

  String name;

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _prefs,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data.getStringList("imagePathList").isNotEmpty) {
            SharedPreferences prefs = snapshot.data;
            List<String> imagePathList = prefs.getStringList("imagePathList");
            /*for(String test in imagePathList) {
              print('hash ${test.substring(test.length - 19, test.length - 13)+test.substring(test.length - 11, test.length - 9)}');
            }
            print("PATH LIST LENGTH  ${imagePathList.length}");
            */

            return new Scaffold(
              appBar: AppBar(
                title: Text("History"),
                backgroundColor: Colors.grey[800],
                actions: <Widget>[
                  IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete History"),
                            content: Text(
                                "Are you sure you want to delete all entries?"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () async {
                                  for (int idx = 0;
                                      idx < imagePathList.length;
                                      idx++) {
                                    String deleteByIdx = imagePathList[idx];
                                    String num = deleteByIdx.substring(
                                        deleteByIdx.length - 9,
                                        deleteByIdx.length - 4);
                                    prefs.remove('Scan$num');
                                    //prefs.remove("Scan$idx");
                                    File(deleteByIdx).deleteSync();
                                  }

                                  imagePathList.forEach((imagePath) {
                                    prefs.remove(imagePath);
                                  });

                                  setState(() {
                                    imagePathList.clear();
                                  });
                                  await prefs.setStringList(
                                      "imagePathList", imagePathList);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("DELETE ALL"),
                              ),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ],
              ),
              body: Container(
                color: Colors.grey[850],
                //padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  //shrinkWrap: true,
                  // reverse: true,

                  itemCount: imagePathList.length, //.compareTo(0),
                  itemBuilder: (context, index) {
                    index = imagePathList.length - 1 - index;
                    String imgPath = imagePathList[index];
                    String num = imgPath.substring(
                        imgPath.length - 9, imgPath.length - 4);
                    String date = imgPath.substring(
                            imgPath.length - 19, imgPath.length - 13) +
                        imgPath.substring(
                            imgPath.length - 11, imgPath.length - 9);
                    //name = prefs.getString("Scan$index");
                    //if (name == null) name = "Scan $index";

                    name = prefs.getString("Scan$num");
                    if (name == null) name = "Scan from $date";
                    return InkWell(
                      onTap: () async {
                        // use index
                        try {
                          if (imagePath == null) imagePath = "";

                          imagePath = await getStringValueFromListSF(index);

                          debugPrint(imagePath);
                          ingredients =
                              await getIngredientsOfProduct(imagePath);

                          ingredients = await checkAllergies(ingredients);

                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DisplayPictureScreen(
                                              appBarTitle: "Scanned product",
                                              imagePath: imagePath,
                                              ingredients: ingredients)))
                              .then((value) => setState(
                                    () => name = prefs.getString("Scan$num"),
                                  ));
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        color: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(
                                    imagePathList[index],
                                  ),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[50],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    //text next to the image
                                    date,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: IconButton(
                                padding: EdgeInsets.all(15),
                                icon: new Icon(
                                  Icons.delete,
                                  color: Colors.grey[50],
                                ),
                                onPressed: () async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        content: const Text(
                                            "Are you sure you want to delete this entry?"),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("CANCEL")),
                                          FlatButton(
                                            onPressed: () async {
                                              String deletePath =
                                                  imagePathList[index];
                                              setState(() {
                                                imagePathList.removeAt(index);
                                                // deleting ingredients for this product
                                                prefs.remove(deletePath);
                                                prefs.remove('Scan$num');
                                              });
                                              File(deletePath).deleteSync();
                                              await prefs.setStringList(
                                                  "imagePathList",
                                                  imagePathList);
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text("DELETE"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("History"),
                backgroundColor: Colors.grey[800],
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[850],
                alignment: Alignment.center,
                child: new Text(
                  "You haven't scanned any products yet.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey[50],
                  ),
                ),
              ),
            );
          }
        },
      );
}
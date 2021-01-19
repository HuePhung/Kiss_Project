import 'dart:io';


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




  Widget getFunctionCards(Ingredient ingredient)
  {
    List<String> strings = ingredient.function.split(",");

    List<String> existingIcons = ["ANTIMICROBIAL","PERFUMING" ,"ANTIOXIDANT","PLACEHOLDER",
    "ANTISTATIC","SKIN CONDITIONING - EMOLLIENT",
    "BINDING",			"SKIN CONDITIONING",
    "CLEANSING",		"SKIN PROTECTING",
    "FILM FORMING",		"SURFACTANT - CLEANSING",
    "FRAGRANCE",			"SURFACTANT - EMULSIFYING",
    "HAIR CONDITIONING"	,	"SURFACTANT - FOAM BOOSTING",
    "HAIR DYEING"		,	"VISCOSITY CONTROLLING",
    "HUMECTANT"];
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < strings.length; i++){


      String path = 'assets/icons/PLACEHOLDER.png';
      //print(strings[i].trim());

      if(existingIcons.contains(strings[i].trim())){

        path = 'assets/icons/'+ strings[i].trim() +'.png';
        //path = 'assets/icons/PLACEHOLDER.png';

      }



      list.add(
          new Card(
            color: Colors.grey[800],
          



          child: Container(
            padding: EdgeInsets.all(10),
            height: 120,
            width: 100,

            child:Column(
              children:[

                Container(
                    height: 55,

                    width: 55,
                child: Image(
                  image: AssetImage(path),
                 // fit: BoxFit.fill,
                ),)
                ,

               Container(
                 height: 45,
               child: Align(
                 alignment: Alignment.center,
                 child:
               FittedBox(
                 fit: BoxFit.fitWidth,
                 child: getTextRight(strings[i])
                ,
          ),),),
              ]
          ),
          ),
      )
      );
    }


    return new Column(
      children: toColumns(list),

    );

  }

  Widget getTextRight(String string){

    List <Widget> columnList = new List<Widget>();
    List<String> list = (string.trim()).split(" ");
    list.remove("-");
    /*if(!(list.length == 1)){
      list.remove("SURFACTANT");

    }*/

    list.forEach((element) {

      columnList.add(Text(

          element,

          style: TextStyle(

              color: Colors.white),

          textAlign: TextAlign.center)
      );


    });



    return new Column(children: columnList);

  }
  List<Widget> toColumns(List<Widget> cards){
    List <Widget> rows = new  List<Widget>();

    List<Widget> row =  new  List<Widget>();
    for(int i=0; i<cards.length;i++){
      
      row.add(cards[i]);
      if(row.length == 3 || i == cards.length-1){
        rows.add(new Row(
            children: row,
          mainAxisAlignment: MainAxisAlignment.center,)
        );
        row =[];
      }
      
    }

    return rows;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Colors.grey[700],
      ),
      //TODO: wrap with container for backgroundcolor
      body: Center(
        child: Container(
          color: Colors.grey[850],
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
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
                        padding: EdgeInsets.fromLTRB(20.0,30,20,0),
                        child: Text(
                          ingredient.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[50],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                           margin: EdgeInsets.fromLTRB(0,15,0,0),
                        child: getFunctionCards(ingredient)
                      ),
                      Card(
                        color: Colors.grey[800],
                        margin: EdgeInsets.fromLTRB(15,15,15,15),
                        child: Container(
                          //height: MediaQuery.of(context).size.height * 0.7,
                          // width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20.0),
                          child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(2),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.top,
                            children: [
                              TableRow(
                                children: [
                                  Text("Description",
                                      style: TextStyle(
                                        color: Colors.grey[50],
                                      ),),
                                  Text(
                                      ingredient.desc != ""
                                          ? ingredient.desc
                                          : "No description found",
                                      style: TextStyle(
                                        color: Colors.grey[50],
                                      ),),
                                ],
                              ),
                             /* TableRow(
                                children: [
                                  Divider(
                                    color: Colors.grey[50],
                                    height: 15,
                                  ),
                                  Divider(
                                    color: Colors.grey[50],
                                    height: 15,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text("Function",
                                      style: TextStyle(
                                        color: Colors.grey[50],
                                      ),),
                                  Text(ingredient.function,
                                      style: TextStyle(
                                        color: Colors.grey[50],
                                      ),),
                                ],
                              ),*/
                              TableRow(
                                children: [
                                  Divider(
                                    color: Colors.grey[50],
                                    height: 15,
                                  ),
                                  Divider(
                                    color: Colors.grey[50],
                                    height: 15,
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text("Allergic",
                                      style: TextStyle(
                                        color: Colors.grey[50],
                                      )),
                                  Container(
                                    child: Row(
                                      children: [
                                        CheckBoxWid(ingredient,),
                                        Expanded(child: Text(
                                          "Check this box if you are allergic to this substance",
                                          style: TextStyle(color: Colors.red),
                                        ),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                                MaterialStateProperty.all(Colors.grey[700],),
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

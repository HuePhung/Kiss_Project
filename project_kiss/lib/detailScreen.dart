import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DetailScreen extends StatelessWidget {
  final appBarTitle;
  final Ingredient ingredient;

  DetailScreen({Key key, @required this.appBarTitle, @required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(//SingleChildScrollView(
          //scrollDirection: Axis.vertical,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: [
                    TableRow(
                      children: [
                        Text("Beschreibung"),
                        Text(ingredient.desc != "" ? ingredient.desc : "Keine Beschreibung gefunden."),
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
                        Text("Funktion"),
                        Text(ingredient.function),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
              //  height: MediaQuery.of(context).size.height * 0.1,
               // width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  child: Text("Google Mich!"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),

                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
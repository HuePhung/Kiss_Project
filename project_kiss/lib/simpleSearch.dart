import 'package:flutter/material.dart';
import 'package:project_kiss/search/ingredient.dart';
import 'csv_reader.dart';
import 'search/levenshtein.dart';
import 'search/fast_levenshtein.dart';
class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  var _searchEdit = new TextEditingController();

  bool _isSearch = true;
  String _searchText = "";

  List<String> _ingridientsListItems;
  List<String> _searchListItems;

  List<String> get ingridientsListItems => _ingridientsListItems;

  FastLevenshtein leven = new FastLevenshtein();

  @override
  void initState() {
    super.initState();
    _ingridientsListItems = new List<String>();
    loadCSV();


    //leven.root.add("ALCOHOL");
  }

  void loadCSV() async {
    var myCSV = CSV.from(path :'assets/cosing.csv', delimiter: ";", title:false);
    bool hasData = await myCSV.initFinished;
    // debugPrint('Step 2, hasData: $hasData');
    for (var i=0; i < myCSV.data.length; i++){
      _ingridientsListItems.add(myCSV.data[i][0]);
      List<String> additionalInfo = myCSV.data[i].sublist(1);
      leven.root.add(myCSV.data[i][0], new Ingredient(myCSV.data[i][0], myCSV.data[i][2], myCSV.data[i][3], myCSV.data[i][4]));


    }
    // Test um den String der  Texterkennung zu zerlegen
    //print(leven.getIndividualItems("HYDROLYZED BEE LARVA EXTRACT ALCOHOL ABALONE EXTRACT"));


  }

  _SecondScreenState() {

    _searchEdit.addListener(() {
      if (_searchEdit.text.isEmpty) {
        setState(() {
          _isSearch = true;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearch = false;
          _searchText = _searchEdit.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Search List"),
      ),
      body: new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: new Column(
          children: <Widget>[
            _searchBox(),
            _isSearch ? _listView() : _searchListView()
          ],
        ),
      ),
    );
  }

  Widget _searchBox() {
    return new Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: new TextField(
        controller: _searchEdit,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: new TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _listView() {

    return new Flexible(
      child: new ListView.builder(
          itemCount: _ingridientsListItems.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              color: Colors.cyan[50],
              elevation: 5.0,
              child: new Container(
                margin: EdgeInsets.all(15.0),
                child: new Text("${_ingridientsListItems[index]}"),
              ),
            );
          }),
    );
  }
  Widget _searchListView() {
    // TODO clean up this mess
    _searchListItems = new List<String>();
    List<String> levenResults;
    String tempItem;
    int max = 5;
    if(tempItem == null){
      tempItem = "no result";
    }
    print(leven.searchForOneIngredient("CANNABINOLK", 1));
    levenResults = leven.search(_searchText.toUpperCase(), 2).keys.toList();

    _searchListItems = levenResults;
    return _searchAddList();
  }

  Widget _searchAddList() {
    return new Flexible(
      child: new ListView.builder(
          itemCount: _searchListItems?.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              color: Colors.cyan[100],
              elevation: 5.0,
              child: new Container(
                margin: EdgeInsets.all(15.0),
                child: new Text("${_searchListItems[index]}"),
              ),
            );
          }),
    );
  }
}
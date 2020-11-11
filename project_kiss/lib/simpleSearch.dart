import 'package:flutter/material.dart';
import 'csv_reader.dart';
import 'levenshtein.dart';

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

  @override
  void initState() {
    super.initState();
    _ingridientsListItems = new List<String>();
    loadCSV();

  }

  void loadCSV() async {
    var myCSV = CSV.from(path :'assets/cosing.csv', delimiter: ",", title:false);
    bool hasData = await myCSV.initFinished;
    // debugPrint('Step 2, hasData: $hasData');
    for (var i=9; i < myCSV.data.length; i++){
      _ingridientsListItems.add(myCSV.data[i][1]);
    }

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
    _searchListItems = new List<String>();
    for (int i = 0; i < _ingridientsListItems.length; i++) {
      var item = _ingridientsListItems[i];
      int distance = Levenshtein.findDistance(item.toLowerCase(), _searchText.toLowerCase());
      if(distance <= 3){
        print(distance);
        _searchListItems.add(item);
      }

    }
    return _searchAddList();
  }

  Widget _searchAddList() {
    return new Flexible(
      child: new ListView.builder(
          itemCount: _searchListItems.length,
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_final/search/fast_levenshtein.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:test_final/search/trie_data_structure.dart';


class SearchScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}
class _SearchScreenState extends State<SearchScreen> {
  var _searchEdit = new TextEditingController();
  bool _isSearch = true;
  String _searchText = "";
  List<Ingredient> _ingredients;
  @override
  void initState() {
    super.initState();
    _ingredients = new List<Ingredient>();
  }
  _SearchScreenState(){
    _searchEdit.addListener(() {
      if (_searchEdit.text.isEmpty) {
        setState(() {
          _ingredients.clear();
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Suche nach Inhaltsstoffen"),
        backgroundColor: Colors.black
      ),
      body: new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: new Column(
          children: <Widget>[
            _searchBox(),
            _isSearch ? _listView(): _searchIngredients()
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
          itemCount: _ingredients?.length,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              onTap: (){
                //TODO this is where we switch to the ingredient screen
                print(_ingredients[index]);
              },
            child: new Card(
            color: Colors.lightGreenAccent[100],
            elevation: 5.0,
            child: new Container(
            margin: EdgeInsets.all(15.0),
            child: new Text("${_ingredients[index].name}"),
            ),
            ),
            );
          }),
    );
  }
  Widget _searchIngredients(){
    _ingredients.clear();
    List<TrieNode> list = FastLevenshtein.search(_searchText.toUpperCase(), 3).values.toList();
    for(int i=0;i<list.length;i++){
      _ingredients.add(list[i].ingredient);
    }
    return _listView();
  }
}

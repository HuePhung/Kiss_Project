import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:test_final/search/fast_levenshtein.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:test_final/detailScreen.dart';
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
  bool _isInAllergyList = false;

  @override
  void initState() {
    super.initState();
    _ingredients = new List<Ingredient>();
  }
  _SearchScreenState() {
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
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
        child: Scaffold(
          appBar: AppBar(
              title: Text("Search for ingredients"),
              backgroundColor: Colors.black,
          ),
          body: Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  RaisedButton(
                    onPressed: ()
                    {
                      setState(()
                      {
                        _isInAllergyList = true;
                        _searchEdit.text = '';
                        _ingredients = FastLevenshtein.getAllergyList();
                        FocusScope.of(context).unfocus();
                      });
                    },
                    child: const Text('Allergies', style: TextStyle(fontSize: 20)),
                  ),
                  _searchBox(),
                  _isSearch ? _listView() : _searchIngredients(_isInAllergyList),
                ],
              ),

            ),

      ),

    );
  }

  Widget _searchBox() {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: TextField(
        controller: _searchEdit,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _listView() {
    return Flexible(
      child: ListView.builder(
          itemCount: _ingredients?.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                print(_ingredients[index]);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => DetailScreen(appBarTitle: "Ingredient", ingredient: _ingredients[index],),
                ),
                ).then((value) =>
                    setState(() {
                      _ingredients = FastLevenshtein.getAllergyList();
                      FocusScope.of(context).unfocus();
                    }));
              },
              child: Card(
                color: _ingredients[index].isAllergic ?  Colors.redAccent[100] : Colors.lightGreenAccent[100],
                elevation: 5.0,
                child: Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text("${_ingredients[index].name}"),
                ),
              ),
            );
          }),
    );
  }

  Widget _searchIngredients(bool allergy){
      _ingredients.clear();

      if (_searchText.isNotEmpty) {
        _ingredients = FastLevenshtein
            .autoComplete(_searchText);
      }
    return _listView();
  }
}

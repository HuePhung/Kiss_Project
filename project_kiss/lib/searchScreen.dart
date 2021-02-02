import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_final/search/fast_levenshtein.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:test_final/detailScreen.dart';
import 'package:test_final/impressumScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  var _searchEdit;
  bool _isSearch = true;
  String _searchText = "";
  List<Ingredient> _ingredients;
  bool _isInAllergyList = false;

  @override
  void dispose() {
    _searchEdit.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ingredients = List<Ingredient>();

    _searchEdit = TextEditingController();
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
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search for ingredients"),
          backgroundColor: Colors.grey[800],
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImpressumScreen()));
              },
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.grey[850],
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: _searchBox(),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(
                        () {
                          _isInAllergyList = true;
                          _searchEdit.text = '';
                          _ingredients = FastLevenshtein.getAllergyList();
                          FocusScope.of(context).unfocus();
                        },
                      );

                      if(_ingredients.isEmpty){
                        final snackbarAllergies = SnackBar(
                            content: Text("Error: No allergies saved."),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.all(18.0),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25)))
                        );
                        Scaffold.of(context).showSnackBar(snackbarAllergies);
                      }
                    },
                    child: const Text(
                      'Allergies',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    padding: EdgeInsets.all(13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Colors.grey[700],
                  ),
                ],
              ),
              _isSearch ? _listView() : _searchIngredients(_isInAllergyList),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(
            5.0)),
        color: Colors.grey[700],
      ),
      child: TextField(
        controller: _searchEdit,
        style: TextStyle(color: Colors.grey[50]),
        decoration: InputDecoration(
          fillColor: Colors.green,
          focusColor: Colors.redAccent,
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey[500]),
          icon: Icon(
            Icons.search,
          ),
        ),
        textAlign: TextAlign.left,
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
                  builder: (context) => DetailScreen(
                    appBarTitle: "Ingredient",
                    ingredient: _ingredients[index],
                  ),
                ),
              ).then((value) => setState(() {
                    _ingredients = FastLevenshtein.getAllergyList();
                    FocusScope.of(context).unfocus();
                  }));
            },
            child: Card(
              color: _ingredients[index].isAllergic
                  ? const Color(0xff9B3535)
                  : Colors.grey[800],
              elevation: 5.0,
              child: Row(children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Text(
                      "${_ingredients[index].name}",
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
          );
        },
      ),
    );
  }

  Widget _searchIngredients(bool allergy) {
    _ingredients.clear();

    if (_searchText.isNotEmpty) {
      _ingredients = FastLevenshtein.autoComplete(_searchText);
    }
    return _listView();
  }
}

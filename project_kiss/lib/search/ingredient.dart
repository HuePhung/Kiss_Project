import 'package:shared_preferences/shared_preferences.dart';

class Ingredient{
  String name;
  String desc;
  String function;
  String date;
  bool isAllergic = false;
  Ingredient(this.name, this.desc, this.function, this.date);
  Ingredient.onlyFunc(this.name,this.function);
  /*void setAllergy(bool isAllergic) async{
    this.isAllergic = isAllergic;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(name, isAllergic);
  }
  Future<bool> getAllergyStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool(name) == null){
      return Future.value(false);
    }
    return prefs.getBool(name);
  }
  void removeAllergyFromPrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.remove(name) != null) {
      prefs.remove(name);
    }
  }*/
  @override
  String toString() {
    return "NAME: $name DESCRIPTION: $desc FUNCTION: $function DATE: $date";
  }
}
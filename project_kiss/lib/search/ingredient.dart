class Ingredient{
  String name;
  String desc;
  String function;
  String date;
  bool isAllergic = false;
  Ingredient(this.name, this.desc, this.function, this.date);
  Ingredient.onlyFunc(this.name,this.function);
  @override
  String toString() {
    return "NAME: $name DESCRIPTION: $desc FUNCTION: $function DATE: $date";
  }

  Ingredient.fromJson(Map<String, dynamic> m){
    name = m['name'];
    desc = m['desc'];
    function = m['function'];
    date = m['date'];
    isAllergic = m["isAllergic"];
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'desc': desc,
    'function': function,
    'date': date,
    'isAllergic': isAllergic,
  };

}
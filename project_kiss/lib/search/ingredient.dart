class Ingredient{
  String name;
  String desc;
  String function;
  String date;

  Ingredient(this.name, this.desc, this.function, this.date);
  Ingredient.onlyFunc(this.name,this.function);

  @override
  String toString() {
    return "NAME: $name DESCRIPTION: $desc FUNCTION: $function DATE: $date";
  }
}
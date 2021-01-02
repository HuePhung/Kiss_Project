
class Levenshtein{

  static int findDistance(String a, String b){
    var d = List.generate(a.length+1, (index) => List(b.length+1), growable: false);

    // Initialising first column
    for(int i=0;i<= a.length;i++){
      d[i][0] = i;
    }
    // Initialising first row:
    for(int j=0;j<= b.length;j++){
      d[0][j] = j;
    }
    // Applying the algorithm:
    int insertion,deletion,replacement;
    for(int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        if(a[i-1]==b[j-1])
          d[i][j] = d[i - 1][j - 1];
        else{
          insertion = d[i][j - 1];
          deletion = d[i - 1][j];
          replacement = d[i - 1][j - 1];
          // Using the sub-problems
          d[i][j] = 1 + findMin(insertion, deletion, replacement);
        }
      }
    }

    return d[a.length][b.length];

  }

  static int findMin(int x, int y, int z){
    if(x <= y && x <= z)
      return x;
    if(y <= x && y <= z)
      return y;
    else
      return z;
  }


  static int getIndexOfStart(List <String>  recogTextList) {
    int minimum = 9223372036854775807;
    int indexMinimum = 0;

    List<String> variants =["INGREDIENTS", "INGREDIENTS/SASTOJCI"];
    for (int i = 0; i < recogTextList.length; i++){

      for (int n=0; n < variants.length; n++){

        int distance = findDistance(variants[n], recogTextList[i].toUpperCase());

        if(distance < minimum){

          minimum = distance;
          indexMinimum = i;

      }


       // print(i);
      }

    }

    if (minimum > 3){
      return 0;
    }
    else{

      return indexMinimum;
    }
  }

}
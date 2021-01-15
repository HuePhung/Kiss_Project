
import 'dart:isolate';

import 'FastLev2.dart';

class SearchIsolate{

  static SendPort childSendPort;
  static  ReceivePort responsePort;

  static init() async {
    ReceivePort receivePort = ReceivePort();
    Isolate.spawn(isolateFunction, receivePort.sendPort);
    childSendPort = await receivePort.first;

    responsePort = ReceivePort();
  }


 static Future useIsolate(String string) async{



    childSendPort.send([string, responsePort.sendPort]);


    var response = await responsePort.first;

    print(response.toString());



    return null ;
  }

  static void isolateFunction(SendPort mainSendPort) async{

    ReceivePort childReceivePort = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);

    await for (var message in childReceivePort) {

      String ingredientString = message[0];
      SendPort replyPort = message[1];
      //FastLevenshtein fastlev = message[2];

     // print("Ankommender String in Isolate: "+ ingredientString);
      if(!NonAsyncLev.loaded){
        NonAsyncLev.init();
      }

      print(NonAsyncLev.root.root.children.length);
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      // var response = await FastLevenshtein.testMethod("AQUA");

      var response = NonAsyncLev.getIndividualItems(ingredientString). then((value) => replyPort.send(value));
      //print(response.toString());
      // print(await FastLevenshtein.testMethod(ingredientString));
      //replyPort.send(response);

    }
  }
}
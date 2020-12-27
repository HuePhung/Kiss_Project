import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImpressumScreen extends StatelessWidget {
  ImpressumScreen({Key key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Impressum"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstrains) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: viewportConstrains.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "lorem ipsum",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "lorem ipsum",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
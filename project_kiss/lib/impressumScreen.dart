import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class ImpressumScreen extends StatelessWidget {
  ImpressumScreen({Key key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("Impressum"),
        backgroundColor: Colors.grey[700],
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
                          "Impressum",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color:Colors.white ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                        child: Text(
'''Angaben gemäß § 5 TMG''',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text('''Projektarbeit „KISS“''',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),


                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Text(
                          '''Haftung für Inhalte

Vertreten durch: 

Henry Ordelt
Kontakt: 
Adresse: Johanna-Tesch-Straße 11, 12439 Berlin
E-Mail: henry@ordelt.de

Die Inhalte unserer Seiten wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen. Als Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt. Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.

Haftung für Links

Unser Angebot enthält Links zu externen Webseiten Dritter, auf deren Inhalte wir keinen Einfluss haben. Deshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.

Urheberrecht

Die durch die Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers. Downloads und Kopien dieser Seite sind nur für den privaten, nicht kommerziellen Gebrauch gestattet. Soweit die Inhalte auf dieser Seite nicht vom Betreiber erstellt wurden, werden die Urheberrechte Dritter beachtet. Insbesondere werden Inhalte Dritter als solche gekennzeichnet. Sollten Sie trotzdem auf eine Urheberrechtsverletzung aufmerksam werden, bitten wir um einen entsprechenden Hinweis. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Inhalte umgehend entfernen.

Google Firebase ML

Die App verwendet den Services „Google Firebase ML“ um eine Texterkennung zu Verfügung zu stellen.
Die Cloud-basierten API speichert hochgeladene Bilder vorübergehend, um die Analyse zu verarbeiten und an Sie zurückzusenden. Gespeicherte Bilder werden normalerweise innerhalb weniger Stunden gelöscht. Weitere Informationen finden Sie unter:''',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
                        ),
                      ),

                      Container(
                        padding:  EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: InkWell(
                            child: new Text('https://cloud.google.com/vision/docs/data-usage',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.normal, color: Color.fromRGBO(118, 185, 0 ,1.0))),
                            onTap: () => launch('https://cloud.google.com/vision/docs/data-usage')
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          '''Firebase-Installationsauthentifizierungstoken werden von Firebase ML zur Geräteauthentifizierung bei der Interaktion mit App-Instanzen verwendet, um beispielsweise Entwicklermodelle an App-Instanzen zu verteilen.
Aufbewahrung: Die Authentifizierungstoken für die Firebase-Installation bleiben bis zu ihrem Ablaufdatum gültig. Die Standard-Token-Lebensdauer beträgt eine Woche.

Quelle der Daten
Die Information zu den Inhaltsstoffen werden aus dem offen Datenportal der EU der Datenbank „CosIng“ bezogen. Mehr Informationen zur Quelle finden Sie hier:''',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: InkWell(
                            child: new Text('https://data.europa.eu/euodp/de/data/dataset/cosmetic-ingredient-database-ingredients-and-fragrance-inventory',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal, color: Color.fromRGBO(118, 185, 0 ,1.0))),
                            onTap: () => launch('https://data.europa.eu/euodp/de/data/dataset/cosmetic-ingredient-database-ingredients-and-fragrance-inventory')
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          '''Impressum in Ausschnitten vom Impressum Generator der Kanzlei Hasselbach, Bonn
''',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
                        ),
                      ),
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}

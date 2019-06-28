import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunderterfeld V0.3',
      debugShowCheckedModeBanner: false,
      home: Hunderterfeld(),
    );
  }
}

class Hunderterfeld extends StatefulWidget {
  //for the screenshot function
  Hunderterfeld({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _Hunderterfeld createState() => _Hunderterfeld();
}

class _Hunderterfeld extends State<Hunderterfeld> {
  //for the array
  static var size = 10;
  var grid = List<List<bool>>.generate(
      size, (i) => List<bool>.generate(size, (j) => false));

  static GlobalKey screen = new GlobalKey();

  //variables for multiplicational and decadal structure
  var m1;
  var m2;
  var d1;
  var d2;

  @override
  Widget build(BuildContext context) {
    //for resetting all circles to blue
    void _backtoblue() {
      setState(() {
        for (int x = 0; x < size; x++) {
          for (int y = 0; y < size; y++) {
            grid[x][y] = false;
          }
        }
      });
    }

    //function for multiplicational structure
    void _multfunc() {
      setState(() {
        for (int x = 0; x < m1 + 1; x++) {
          for (int y = 0; y < m2 + 1; y++) {
            grid[x][y] = true;
          }
        }
      });
    }

    //function for decadal structure
    void _decfunc() {
      setState(() {
        for (int x = 0; x < d1; x++) {
          for (int y = 0; y < 10; y++) {
            grid[x][y] = true;
          }
        }
      });
      setState(() {
        for (int m = 0; m < d2 + 1; m++) {
          grid[d1][m] = true;
        }
      });
    }

    //for the screenshot function
    screenShot() async {
      RenderRepaintBoundary boundary = screen.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      var filePath = await ImagePickerSaver.saveFile(
          fileData: byteData.buffer.asUint8List());
      print(filePath);
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Hunderterfeld'),
        backgroundColor: Colors.grey,
        actions: <Widget>[
          //IconButton(
          //icon: Icon(Icons.edit), tooltip: 'Zeichne', onPressed: () {}),
          IconButton(
              icon: Icon(Icons.photo_camera),
              tooltip: 'Screenshot',
              onPressed: () {
                screenShot();
                print("Foto");
              }),
          IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Zurücksetzen auf Blau',
              onPressed: () {
                _backtoblue();
                print("Eimer");
              }),
          IconButton(
              icon: Icon(Icons.info_outline),
              tooltip: 'Infos',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                            title: new Text("Informationen zur Handhabung"),
                            content: new Text(
                                "Mit einem Klick auf die Kreise können Sie die Farbe auf rot (und wieder auf blau) wechseln. \nMit einem Doppelklick auf einen Kreis wird das Rechteck ausgehend von oben links zum Punkt rot gefärbt. Somit können Sie multiplikative Strukturen visualisieren. \nMit einem Langdruck auf einen Punkt wird die dekadische Struktur bis zu diesem Punkt eingefärbt. \nMit einem Klick auf den Mülleimer können Sie alle Punkte auf blau zurücksetzen. \nMit einem Klick auf den Fotoapparat können Sie einen Screenshot des aktuellen Hunderterfeldes machen. Dazu benötigt die App eine entsprechende Berechtigung (Android: \"Zugriff auf Fotos, Medien und Dateien\")."),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ]));
              }),
        ],
      ),
      body: RepaintBoundary(
        key: screen,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: AspectRatio(
              aspectRatio: 1.0 / 1.0,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile01
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[0][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 0;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 0;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[0][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile02
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[1][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 1;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 1;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[1][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile03
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[2][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 2;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 2;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[2][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile04
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[3][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 3;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 3;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[3][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile05
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[4][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 4;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 4;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[4][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile06
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[5][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 5;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 5;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[5][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile07
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[6][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 6;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 6;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[6][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile08
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[7][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 7;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 7;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[7][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile09
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[8][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 8;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 8;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[8][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        //Zeile10
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][0] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 0;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 0;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][0] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][1] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 1;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 1;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][1] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][2] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 2;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 2;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][2] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][3] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 3;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 3;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][3] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][4] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 4;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 4;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][4] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][5] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 5;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 5;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][5] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][6] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 6;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 6;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][6] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][7] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 7;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 7;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][7] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][8] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 8;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 8;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][8] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      grid[9][9] ^=
                                          true; //switches the state between true and false
                                    });
                                  },
                                  onDoubleTap: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        m1 = 9;
                                        m2 = 9;
                                      },
                                    );
                                    _multfunc();
                                  },
                                  onLongPress: () {
                                    _backtoblue();
                                    setState(
                                      () {
                                        d1 = 9;
                                        d2 = 9;
                                      },
                                    );
                                    _decfunc();
                                  },
                                  onVerticalDragUpdate: (e) {
                                    print("VertikalesDragupdate");
                                  },
                                  onHorizontalDragUpdate: (e) {
                                    print("HorizontalesDragupdate");
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      return new Icon(
                                        Icons.brightness_1,
                                        size: constraint.biggest.height,
                                        color: (grid[9][9] == false
                                            ? Colors.blue[900]
                                            : Colors.red),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

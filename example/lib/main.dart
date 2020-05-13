import 'package:flutter/material.dart';
import 'package:speed_dial/speed_dial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Speed dial example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: Text(_text)),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
              child: Icon(Icons.directions_run),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              label: 'Let\'s start a run!',
              onPressed: () {
                setState(() {
                  _text = 'You pressed \"Let\'s start a run!\"';
                });
              }),
          SpeedDialChild(
              child: Icon(Icons.directions_walk),
              foregroundColor: Colors.black,
              backgroundColor: Colors.yellow,
              label: 'Let\'s start go for a walk!',
              onPressed: () {
                setState(() {
                  _text = 'You pressed \"Let\'s go for a walk!\"';
                });
              }),
          SpeedDialChild(
              child: Icon(Icons.directions_bike),
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              label: 'Let\'s go cycling!',
              onPressed: () {
                setState(() {
                  _text = 'You pressed \"Let\'s go cycling!\"';
                });
              })
        ],
        closedForegroundColor: Colors.black,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.white,
        openBackgroundColor: Colors.black,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Speed dial example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
        child: const Icon(Icons.add),
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.directions_run),
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            label: 'Let\'s go for a run!',
            onPressed: () {
              setState(() {
                _text = 'You pressed "Let\'s go for a run!"';
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.directions_walk),
            foregroundColor: Colors.black,
            backgroundColor: Colors.yellow,
            label: 'Let\'s go for a walk!',
            onPressed: () {
              setState(() {
                _text = 'You pressed "Let\'s go for a walk!"';
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.directions_bike),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            label: 'Let\'s go cycling!',
            onPressed: () {
              setState(() {
                _text = 'You pressed "Let\'s go cycling!"';
              });
            },
          ),
        ],
        closedForegroundColor: Colors.black,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.white,
        openBackgroundColor: Colors.black,
      ),
    );
  }
}

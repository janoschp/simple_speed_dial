# simple_speed_dial

A simple speed dial widget for Flutter.

Demonstration: 

![](screenshots/demo.gif)

Usage:

```dart
Scaffold(
  floatingActionButton: SpeedDial(
    child: Icon(Icons.add),
    closedForegroundColor: Colors.black,
    openForegroundColor: Colors.white,
    closedBackgroundColor: Colors.white,
    openBackgroundColor: Colors.black,
    labelsStyle: /* Your label TextStyle goes here */,
    controller: /* Your custom animation controller goes here */,
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
        },
        closeSpeedDialOnPressed: false,
      ),
      SpeedDialChild(
        child: Icon(Icons.directions_walk),
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow,
        label: 'Let\'s go for a walk!',
        onPressed: () {
          setState(() {
            _text = 'You pressed \"Let\'s go for a walk!\"';
          });
        },
      ),
      //  Your other SpeeDialChildren go here.        
    ],
  ),
);
```
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GhostMain extends StatefulWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;
  GhostMain(this._prefs, this._ghostReleased);

  @override
  _GhostMainState createState() => _GhostMainState(_prefs, _ghostReleased);
}

class _GhostMainState extends State<GhostMain> {
  _GhostMainState(this._prefs, this._ghostReleased);

  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  var options = ["Hello", "What is your name?", "Blah", "Foo"];
  var response = ["Hi", "Ghost", "Bloo", "Bar"];
  var currentResponse = _prefs.getBool("has_ghost")
              ? "Your ghost is: " + _prefs.getInt("ghost_id").toString()
              : "No ghost selected, how'd you get here?";

  void buttonHandler(int id) {
    setState(() {
      currentResponse = response[id];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 100),
        child: Column(
          children: <Widget>[
            Text(
              currentResponse,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                fontSize: 42,
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => buttonHandler(0),
                  child: Text(options[0]),
                ),
                RaisedButton(
                  onPressed: () => buttonHandler(1),
                  child: Text(options[1]),
                ),
                RaisedButton(
                  onPressed: () => buttonHandler(2),
                  child: Text(options[2]),
                ),
                RaisedButton(
                  onPressed: () => buttonHandler(3),
                  child: Text(options[3]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
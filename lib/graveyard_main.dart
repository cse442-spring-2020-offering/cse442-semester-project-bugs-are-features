import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraveyardMain extends StatelessWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is chosen.
  final VoidCallback _ghostChosen;

  GraveyardMain(this._prefs, this._ghostChosen);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      padding: EdgeInsets.all(8.0),
      children: <Widget>[
        makeGhostPicker(1),
        makeGhostPicker(2),
        makeGhostPicker(3),
        makeGhostPicker(4),
        makeGhostPicker(5),
        makeGhostPicker(6),
        makeGhostPicker(7),
        makeGhostPicker(8),
        makeGhostPicker(9)
      ],
    ));
  }

  Container makeGhostPicker(int id) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          splashColor: Colors.blueAccent,
          shape: new ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)),
          onPressed: () {
            _prefs.setInt("ghost_id", id);
            _prefs.reload();
            _ghostChosen();
          },
          child: Text(
            "Ghost " + id.toString(),
            style: TextStyle(fontSize: 20.0),
          ),
        ));
  }
}
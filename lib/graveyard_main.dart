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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Image.asset(
          'assets/misc/Graveyard.png',
          width: size.width,
          height: size.height,
          fit: BoxFit.fill,
        ),
        Center(
          child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3,
              padding: EdgeInsets.all(8.0),
              children: List.generate(2, (index) {
                return makeGhostPicker(context, index + 1);
              })),
        ),
      ],
    ));
  }

  Container makeGhostPicker(BuildContext context, int id) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
          color: Theme
              .of(context)
              .buttonColor,
          textColor: Theme
              .of(context)
              .textTheme
              .body1
              .color,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          splashColor: Theme
              .of(context)
              .accentColor,
          shape: BeveledRectangleBorder(
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              side: BorderSide(color: Theme
                  .of(context)
                  .backgroundColor)),
          onPressed: () {
            print(id);
            _prefs.setInt("ghost_id", id);
            _ghostChosen();
          },
          child: Text(
            "Ghost ${id.toString()}",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
  }
}

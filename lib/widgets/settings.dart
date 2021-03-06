import 'package:Inspectre/models/game.dart';
import 'package:flutter/material.dart';

/// The Settings modal that fades in when the Settings button is pressed.
///
/// This widget is pretty straightforward. The user can changed settings here.
/// This may need to be updated to a StatefulWidget in the future to reflect
/// any settings that a user has changed right away.
class Settings extends StatelessWidget {
  /// The game instances
  final Game _game;

  Settings(this._game);

  @override
  Widget build(BuildContext context) {
    bool pressAttention = false; //toggled when release ghost is pressed
    int ghostId = _game.prefs.getInt('ghost_id');

    return Container(
        constraints: BoxConstraints(
            maxHeight: 300.0,
            maxWidth: 250.0,
            minWidth: 250.0,
            minHeight: 150.0),
        color: Theme.of(context).backgroundColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: Text("Settings",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 35.0)),
              ),
              Visibility(
                visible: ghostId == 0 ? false : true,
                child: FlatButton(
                  color: pressAttention
                      ? Theme.of(context).buttonColor
                      : Colors.red[700],
                  textColor: Theme.of(context).textTheme.body1.color,
                  onPressed: () {
                    _setState(pressAttention);
                    _showAlertOnRelease(context);
                  },
                  child: Text("Release ghost",
                      style: Theme.of(context).textTheme.body1),
                ),
              ),
            ]));
  }

  ///Shows the Alert dialogue on pressing Release ghost
  void _showAlertOnRelease(BuildContext context) {
    // set up the buttons
    Widget noButton = FlatButton(
      color: Theme.of(context).buttonColor,
      child: Text("No, I miss the ghost.",
          style: Theme.of(context).textTheme.body1),
      onPressed: () {
        _closeDialog(context);
      },
    );

    Widget yesButton = FlatButton(
      color: Colors.red,
      child: Text("Yes, Release the ghost",
          style: Theme.of(context).textTheme.body1),
      onPressed: () {
        _game.ghostReleased();
        _closeDialog(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog", style: Theme.of(context).textTheme.body1),
      backgroundColor: Theme.of(context).backgroundColor,
      content: Text("Are you sure you wanna release the ghost?",
          style: Theme.of(context).textTheme.body1),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ///set state of presAttention to true when Release ghost is pressed.
  void _setState(bool pressAttention) {
    pressAttention = true;
  }

  ///Closes the dialog
  void _closeDialog(BuildContext context) {
    Navigator.pop(context);
  }
}

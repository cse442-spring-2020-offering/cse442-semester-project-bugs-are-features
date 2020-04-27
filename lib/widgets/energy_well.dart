import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/energy.dart';
import 'package:ghost_app/models/game.dart' as Game;
import 'package:ghost_app/models/ghost_model.dart';
import 'package:ghost_app/models/timers.dart';

class EnergyWell extends StatefulWidget {
  /// Whether or not the user can interact with the ghost
  final bool _canInteract;

  /// The current Ghost instances
  final GhostModel _ghost;

  /// The Timers model containing all timers
  final Timers _timers;

  final DB _db;

  final Energy _energy;

  final VoidCallback _refresh;

  EnergyWell(this._canInteract, this._ghost, this._energy, this._timers,
      this._db, this._refresh);

  @override
  _EnergyWellState createState() => _EnergyWellState();
}

class _EnergyWellState extends State<EnergyWell> {
  /// Whether or not the user can press this button
  bool _active;

  /// How much score is added from giving energy
  int _scoreIncrease = 15;

  @override
  initState() {
    super.initState();

    if (widget._timers.energyWellTimer != null &&
        widget._timers.energyWellTimer.isActive) {
      _active = true;
      // TODO: Get time left stored in db
      this.widget._energy.energy = widget._db.getCurrentEnergy();
    } else {
      _reset();
    }
  }

  ///Gives energy to the ghost if player clicks on the give energy icon.
  ///Player energy: -40
  ///Player score: +75
  _donateEnergy() async {
    int newEnergy = widget._energy.energy - 40;
    if (newEnergy < 0) {
      return;
    }

    widget._energy.energy = newEnergy;
    if (_scoreIncrease == 0) {
      widget._energy.energy -= 10;
    }
    await widget._ghost.addScore(_scoreIncrease);

    setState(() {
      _active = !_active;
      debugPrint("-40 Energy donated. Energy set to ${widget._energy.energy}");
      _startTimer();
    });
    widget._refresh();
  }

  /// Resets states allowing user to hit button again
  _reset() {
    setState(() {
      _active = true;
      widget._timers.resetEnergyWellRemaining();
    });
  }

  /// Called on every tick second of the countdown
  _tick(Timer timer) {
    setState(() {
      widget._timers.energyWellRemaining -= 1;
      if (widget._timers.energyWellRemaining == 0) {
        widget._timers.cancelEnergyWellTimer();
        _reset();
      }
    });
  }

  /// Start the countdown timer for the energy well
  _startTimer() {
    widget._timers.energyWellTimer = Timer.periodic(Game.ONE_SECOND, _tick);
    setState(() {
      _active = false;
    });
  }

  /// Stack widget used to overlay text over image
  Widget _loadImage() {
    var img;
    if (_active) {
      img = Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Image.asset('assets/misc/GiveEnergyFull.png', height: 65, width: 65),
        ],
      );
    } else {
      img = Stack(alignment: Alignment.centerRight, children: <Widget>[
        Image.asset('assets/misc/GiveEnergyEmpty.png', height: 65, width: 65),
        Positioned(
            bottom: 24,
            left: 15,
            right: 15,
            child: Column(
              children: <Widget>[
                Text(
                  widget._timers.energyWellRemaining.toString(),
                  style: Theme
                      .of(context)
                      .textTheme
                      .body1
                      .copyWith(fontSize: 15.0),
                )
              ],
            ))
      ]);
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
//        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: _active && widget._canInteract ? _donateEnergy : null,
                child: _loadImage()),
          ],
        ));
  }
}
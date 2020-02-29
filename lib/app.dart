import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghost_app/db/db.dart';

import 'widgets/splash_screen.dart';
import 'ghost_main.dart';
import 'graveyard_main.dart';
import 'widgets/settings_button.dart';

/// RootPage is the "actual" root widget of the app. See also [_RootPageState].
///
/// This widget renders the two secondary main screens, [GraveyardMain] or the
/// [GhostMain], based upon preference values in SavedPreferences. In particular,
/// if the preferences show [has_ghost] to be `true`, this widget will render
/// the [GhostMain] container. otherwise it will render [GraveyardMain].
///
/// It also displays a splash screen when the app is opened and is home to the
/// Settings widget, which is displayed persistently on the same layer as
/// [GhostMain] and [GraveyardMain]. This allows it to display a floating Settings
/// widget above either of those two screens.
class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

/// The state widget of [RootPage].
class _RootPageState extends State<RootPage> {
  /// The Database instance
  final DB _database = DB();

  /// Displays splash screen when false. True when assets are loaded.
  bool _assetsLoaded = false;

  /// Instance of app preferences. Is passed to children.
  SharedPreferences _prefs;

  @override
  initState() {
    super.initState();
    _loadAssets();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Display splash screen until assets are loaded.
    if (!_assetsLoaded) {
      return SplashScreen();
    }

    var view = <Widget>[];
    // Select our main view container.
    if (_prefs.getBool('has_ghost')) {
      GhostMain ghost = GhostMain(_prefs, _ghostReleased);
      view.add(ghost);
    } else {
      GraveyardMain graveyard = GraveyardMain(_prefs, _ghostChosen);
      view.add(graveyard);
    }

    view.add(SettingsButton(_prefs, _ghostReleased, _ghostChosen));

    return Stack(children: view);
  }

  /// For all future image, sound, and startup database calls.
  _loadAssets() async {
    _readPrefs();

    // Hold splash screen.
    Timer(Duration(seconds: 2), () {
      setState(() {
        _assetsLoaded = true;
      });
    });
  }

  /// Grabs our instance of SharedPreferences to pass to children.
  _readPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // Check if this is our first app launch so we can init preferences.
    if (_prefs.getBool('first_launch') ?? true) {
      _initPrefs();
    }
  }

  /// Initialize all needed preferences at first launch with defaults.
  _initPrefs() {
    // TODO: Delineate all the preferences we'll need.
    _prefs.setBool('first_launch', false);
    _prefs.setBool('has_ghost', false);
  }

  /// Call from [GraveyardMain] when a ghost is select to render [GhostMain].
  _ghostChosen() {
    setState(() {
      _prefs.setBool('has_ghost', true);
    });
  }

  /// Call from [GhostMain] when a ghost is select to render [GraveyardMain].
  _ghostReleased() {
    setState(() {
      _prefs.setBool('has_ghost', false);
    });
  }
}
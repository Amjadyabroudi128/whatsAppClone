// presence_controller.dart
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'FirebaseAuth.dart';

class PresenceController with WidgetsBindingObserver {
  final FirebaseService _service;

  PresenceController(this._service);

  void attach() {
    WidgetsBinding.instance.addObserver(this);
    _setOnline(); // app just started / attached
  }

  void detach() {
    WidgetsBinding.instance.removeObserver(this);
    _setOffline();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    switch(state){
      case AppLifecycleState.resumed:
        _setOnline();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _setOffline();
        break;
      default:
        break;

    }
  }
  void _setOnline() {
    _service.onlineStatues(true);
  }

  void _setOffline() {
    _service.onlineStatues(false);
  }
}

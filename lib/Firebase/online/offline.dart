// presence_controller.dart
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../FirebaseAuth.dart';

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final loggedIn = FirebaseAuth.instance.currentUser != null;
    if (!loggedIn) return;

    if (state == AppLifecycleState.resumed) {
      _setOnline();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _setOffline();
    }
  }

  void _setOnline() {
    _service.onlineStatues(true);
  }

  void _setOffline() {
    _service.onlineStatues(false);
  }
}

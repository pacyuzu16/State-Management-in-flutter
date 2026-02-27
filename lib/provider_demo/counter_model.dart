// ─────────────────────────────────────────────────────────────────────────────
// STEP 2: Creating a State Class
//
// - Extend ChangeNotifier to make this class "observable"
// - Hold state variables here (private with getters)
// - Call notifyListeners() after any state change to trigger UI rebuilds
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';

class CounterModel extends ChangeNotifier {
  // Private state variable — cannot be changed directly from outside
  int _count = 0;

  // Public getter — widgets read state through this
  int get count => _count;

  // ── Methods that update state ──────────────────────────────────────────────

  void increment() {
    _count++;
    notifyListeners(); // Tells all listening widgets to rebuild
  }

  void decrement() {
    if (_count > 0) _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

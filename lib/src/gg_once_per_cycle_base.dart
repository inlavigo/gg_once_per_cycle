import 'dart:async';

/// Takes a [task] and makes sure that [trigger] does execute the task only
/// one time in a run loop cycle.
class GgOncePerCycle {
  /// The [task] to be triggered only one time in a run loop cycle.
  GgOncePerCycle({required this.task});

  /// Call this method if triggered tasks shoult not be triggered anymore
  void dispose() {
    _isDisposed = true;
  }

  /// The task to be triggered
  void Function() task;

  /// This method triggers the task, but only if it has not already been
  /// executed during this run loop cycle.
  void trigger() {
    if (_isTriggered) {
      return;
    }

    _isTriggered = true;
    scheduleMicrotask(() {
      _isTriggered = false;
      if (!_isDisposed) {
        task();
      }
    });
  }

  bool _isTriggered = false;
  bool _isDisposed = false;
}

import 'dart:async';

/// Takes a [task] and makes sure that [trigger] does execute the task only
/// one time in a run loop cycle.
class GgOncePerCycle {
  /// The [task] to be triggered only one time in a run loop cycle.
  ///
  /// If [isTest] is true, task will not be executed automatically.
  /// In that case call [executeNow()].
  GgOncePerCycle({required this.task, this.isTest = false});

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

    if (isTest) {
      return;
    }

    scheduleMicrotask(_scheduledTask);
  }

  /// The task will only be triggered once in a cycle.
  /// Use `[isTest] = false` and `executeNow()` to control the execution.
  void executeNow() => _scheduledTask();

  bool _isTriggered = false;
  bool _isDisposed = false;
  final bool isTest;

  void _scheduledTask() {
    _isTriggered = false;
    if (!_isDisposed) {
      task();
    }
  }
}

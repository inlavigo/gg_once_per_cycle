import 'dart:async';

/// Takes a [task] and makes sure that [trigger] does execute the task only
/// one time in a run loop cycle.
class GgOncePerCycle {
  /// The [task] to be triggered only one time in a run loop cycle.
  ///
  /// If [isTest] is true, task will not be executed automatically.
  /// In that case call [executeNow()].
  ///
  /// If [scheduleTask] callback is set, tasks will be scheduled using this
  /// function. Otherwise dart's [scheduleMicrotask] will be used.
  GgOncePerCycle({
    required this.task,
    this.isTest = false,
    this.scheduleTask = scheduleMicrotask,
  });

  /// Call this method if triggered tasks shoult not be triggered anymore
  void dispose() {
    _isDisposed = true;
  }

  /// The task to be triggered
  void Function() task;

  /// This method triggers the task, but only if it has not already been
  /// executed during this run loop cycle.
  ///
  /// [If scheduleTask is set, this method will used to trigger the task]
  void trigger({
    Function(void Function() task)? scheduleTask,
  }) {
    if (_isTriggered) {
      return;
    }

    _isTriggered = true;

    if (isTest) {
      return;
    }

    (scheduleTask ?? this.scheduleTask).call(_scheduledTask);
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

  late Function(void Function() task) scheduleTask;
}

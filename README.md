# Trigger tasks multiple times, but execute them only one time per run loop cycle

Use `GgOncePerCycle` to trigger tasks multiple times while ensuring they are
only executed one time during a run loop cycle.

## Usage

A simple usage example:

```dart
import 'package:gg_once_per_cycle/gg_once_per_cycle.dart';

void main() async {
  // Create a task
  var counter = 0;
  task() => print('Task ${++counter}');

  // Give the task to a OncePerCycle instance
  final oncePerCycle = GgOncePerCycle(task: task);

  // Trigger the task multiple times
  oncePerCycle.trigger();
  oncePerCycle.trigger();
  oncePerCycle.trigger();

  // Wait for the next cycle
  await Future.delayed(Duration(microseconds: 1));

  // The task has only called one time
  assert(counter == 1);

  // Now we are in the next cycle and trigger the task again
  oncePerCycle.trigger();
  oncePerCycle.trigger();

  await Future.delayed(Duration(microseconds: 1));

  // And again the task has called only one other time
  assert(counter == 2);

  // Output:
  // Task 1
  // Task 2

  // Finally dispose the trigger to prevent that things
  // are executed lately.
  oncePerCycle.dispose();
  oncePerCycle.trigger();

  // Output:
  // No output, because previous dispose

  // ..................................................................
  // Assume a test where you want to control the execution by yourself
  var counterBefore = counter;
  final oncePerCycleTest = GgOncePerCycle(task: task, isTest: true);

  // Trigger
  oncePerCycleTest.trigger();
  await Future.delayed(Duration(microseconds: 1));

  // Nothing has happened, because isTest is true.
  assert(counter == counterBefore);

  // Trigger execution manually
  oncePerCycleTest.executeNow();

  // Now the task is executed
  assert(counter == counterBefore + 1);

  // ..................................................
  // Use Future.microtask instead of scheduleMicrotask
  counterBefore = counter;
  final ownScheduleMethodTest = GgOncePerCycle(
    task: task,
    scheduleTask: Future.microtask,
  );

  // Trigger
  ownScheduleMethodTest.trigger();
  await Future.delayed(Duration(microseconds: 1));

  // Now the task is executed
  assert(counter == counterBefore + 1);
}
```

## Features and bugs

Please file feature requests and bugs at [GitHub][tracker].

[tracker]: https://github.com/gatzsche/gg_once_per_cycle

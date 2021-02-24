import 'package:gg_once_per_cycle/gg_once_per_cycle.dart';

void main() async {
  // Create a task
  var counter = 0;
  final task = () => print('Task ${++counter}');

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
}

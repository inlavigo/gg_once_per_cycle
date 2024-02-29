import 'package:fake_async/fake_async.dart';
import 'package:gg_once_per_cycle/src/gg_once_per_cycle.dart';
import 'package:test/test.dart';

void main() {
  group('GgTriggerOnce', () {
    // #########################################################################
    group('should only trigger one time in a run loop cycle', () {
      test('should be instantiated', () {
        fakeAsync((fake) {
          var callCounter = 0;
          int callback() => callCounter++;
          final triggerOnce = GgOncePerCycle(task: callback);
          triggerOnce.trigger();
          triggerOnce.trigger();
          triggerOnce.trigger();
          expect(callCounter, 0);
          fake.flushMicrotasks();
          expect(callCounter, 1);
          triggerOnce.trigger();
          triggerOnce.trigger();
          fake.flushMicrotasks();
          expect(callCounter, 2);
        });
      });

      test('should not trigger a triggered task, once dispose is called', () {
        fakeAsync((fake) {
          // Create an object
          var callCounter = 0;
          int callback() => callCounter++;
          final triggerOnce = GgOncePerCycle(task: callback);

          // oncPerCycle is undisposed -> triggers are executed
          triggerOnce.trigger();
          fake.flushMicrotasks();
          expect(callCounter, 1);

          // oncePerCycle is disposed -> triggers are not executed anymore
          final callCounterBefore = callCounter;
          triggerOnce.dispose();
          triggerOnce.trigger();
          fake.flushMicrotasks();
          expect(callCounter, callCounterBefore);
        });
      });

      test('should not automatically execute task when isTest is true', () {
        fakeAsync((fake) {
          // Create an object
          var callCounter = 0;
          int callback() => callCounter++;
          final triggerOnce = GgOncePerCycle(task: callback, isTest: true);

          // oncPerCycle is undisposed -> triggers are executed
          triggerOnce.trigger();

          // Lets wait.
          fake.flushMicrotasks();

          // Task is not executed, because isTest is true.
          expect(callCounter, 0);

          // Trigger the execution manually.
          triggerOnce.executeNow();

          // Now the task is executed.
          expect(callCounter, 1);
        });
      });

      test('should use scheduleTask callback when given in constructor', () {
        // Create an object
        var callCounter = 0;
        int callback() => callCounter++;
        var didUseOurScheduleMethod = false;

        void scheduleTask(void Function() task) {
          task();
          didUseOurScheduleMethod = true;
        }

        final triggerOnce = GgOncePerCycle(
          task: callback,
          scheduleTask: scheduleTask,
        );

        // Trigger the task
        triggerOnce.trigger();

        // Now the task is executed immedediately
        expect(callCounter, 1);
        expect(didUseOurScheduleMethod, isTrue);
      });

      test('should use scheduleTask callback when given in trigger', () {
        // Create an object
        var callCounter = 0;
        int callback() => callCounter++;

        var didUseOurScheduleMethod = false;

        void scheduleTask(void Function() task) {
          task();
          didUseOurScheduleMethod = true;
        }

        final triggerOnce = GgOncePerCycle(task: callback);

        // Trigger the task with defining a scheduleTask method
        triggerOnce.trigger(scheduleTask: scheduleTask);

        // Now the task is executed immedediately
        expect(callCounter, 1);
        expect(didUseOurScheduleMethod, isTrue);
      });
    });
  });
}

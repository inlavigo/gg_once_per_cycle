import 'package:fake_async/fake_async.dart';
import 'package:gg_once_per_cycle/gg_once_per_cycle.dart';
import 'package:test/test.dart';

void main() {
  group('GgTriggerOnce', () {
    // #########################################################################
    group('should only trigger one time in a run loop cycle', () {
      test('should be instantiated', () {
        fakeAsync((fake) {
          var callCounter = 0;
          final callback = () => callCounter++;
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
    });
  });
}

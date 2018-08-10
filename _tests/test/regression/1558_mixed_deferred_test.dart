@TestOn('browser')
import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import '1558_mixed_deferred_test.template.dart' as ng;

// See https://github.com/dart-lang/angular/issues/1558.
void main() {
  test('should allow deferring some components from an import', () async {
    // Previously, if you had library "a.dart", and it had Comp1 and Comp2, and
    // Comp1 was imported and used with "@deferred", and Comp2 was not used with
    // "@deferred", a compiler error would be thrown by DDC/Dart2JS:
    //   "The deferred type deflib0.Comp2 can't be used in a ..."
    //
    // This is because the emitter would try re-using the "deferred as" import
    // (generated by the compiler) to refer to types (including Comp2) that were
    // not meant to be deferred.
    await NgTestBed.forComponent(ng.MixedDeferredTestNgFactory).create();
  });
}

@Component(
  selector: 'mixed-deferred-test',
  template: r'''
    <comp-1 @deferred></comp-1>
    <comp-2></comp-2>
  ''',
  directives: [
    Comp1,
    Comp2,
  ],
)
class MixedDeferredTest {}

@Component(
  selector: 'comp-1',
  template: '',
)
class Comp1 {}

@Component(
  selector: 'comp-2',
  template: '',
)
class Comp2 {}
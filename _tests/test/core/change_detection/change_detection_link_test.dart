@TestOn('browser')
import 'package:test/test.dart';
import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';

import 'change_detection_link_test.template.dart' as ng;

void main() {
  tearDown(disposeAnyRunningTest);

  group('CheckAlways component should always be checked when loaded', () {
    MutableState state;

    setUp(() {
      state = MutableState('Initial value');
    });

    Future<void> testComponent(ComponentFactory<void> componentFactory) async {
      final testBed = NgTestBed.forComponent(
        componentFactory,
        rootInjector: ([parent]) {
          return Injector.map({MutableState: state}, parent);
        },
      );
      final testFixture = await testBed.create();
      expect(testFixture.text, 'Initial value');
      await testFixture.update((_) {
        state.value = 'Changed value';
      });
      expect(testFixture.text, 'Changed value');
    }

    // CheckAlways (passes factory) ->
    //      \   @changeDetectionLink OnPush (loads factory) -> CheckAlways
    //       \_____________________________________________________/
    //            CheckAlways change detection link
    //
    test('in a @changeDetectionLink OnPush component', () {
      return testComponent(ng.LoadInOnPushNgFactory);
    });

    // CheckAlways (passes factory) ->
    //      \   @changeDetectionLink OnPush (passes factory) ->
    //       \    @changeDetectionLink OnPush (loads factory) -> CheckAlways
    //        \______________________________________________________/
    //            CheckAlways change detection link
    //
    test('through multiple @changeDetectionLink OnPush components', () {
      return testComponent(ng.LoadInOnPushDescendantNgFactory);
    });

    // CheckAlways (passes factory) ->
    //      \   @changeDetectionLink OnPush (loads template) ->
    //       \    embedded view (loads factory) -> CheckAlways
    //        \_________________________________________/
    //            CheckAlways change detection link
    //
    test('in an embedded view of a @changeDetectionLink OnPush component', () {
      return testComponent(ng.LoadInOnPushEmbeddedViewNgFactory);
    });
  }, skip: 'b/119571379');
}

/// A shared model whose internal state is mutable.
class MutableState {
  MutableState(this.value);

  String value;
}

/// A component that relies on default change detection to observe mutations.
@Component(
  selector: 'default',
  template: '{{state.value}}',
)
class DefaultComponent {
  DefaultComponent(this.state);

  final MutableState state;
}

// TODO(b/119571379): @changeDetectionLink
@Component(
  selector: 'on-push-container',
  template: '<template #container></template>',
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class OnPushContainerComponent {
  @Input()
  set componentFactory(ComponentFactory<Object> value) {
    viewContainerRef.createComponent(value);
  }

  @ViewChild('container', read: ViewContainerRef)
  ViewContainerRef viewContainerRef;
}

@Component(
  selector: 'test',
  template: '''
    <on-push-container [componentFactory]="defaultComponentFactory">
    </on-push-container>
  ''',
  directives: [OnPushContainerComponent],
)
class LoadInOnPush {
  static final defaultComponentFactory = ng.DefaultComponentNgFactory;
}

// TODO(b/119571379): @changeDetectionLink
@Component(
  selector: 'on-push-ancestor',
  template: '''
    <on-push-container [componentFactory]="componentFactory">
    </on-push-container>
  ''',
  directives: [OnPushContainerComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class OnPushAncestorComponent {
  @Input()
  ComponentFactory<Object> componentFactory;
}

@Component(
  selector: 'test',
  template: '''
    <on-push-ancestor [componentFactory]="defaultComponentFactory">
    </on-push-ancestor>
  ''',
  directives: [OnPushAncestorComponent],
)
class LoadInOnPushDescendant {
  static final defaultComponentFactory = ng.DefaultComponentNgFactory;
}

// TODO(b/119571379): @changeDetectionLink
@Component(
  selector: 'on-push-embedded-container',
  template: '''
    <ng-container *ngIf="isContainerVisible">
      <template #container></template>
    </ng-container>
  ''',
  directives: [NgIf],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class OnPushEmbeddedContainerComponent {
  OnPushEmbeddedContainerComponent(this._changeDetectorRef, this._ngZone);

  final ChangeDetectorRef _changeDetectorRef;
  final NgZone _ngZone;

  var isContainerVisible = true;

  @Input()
  ComponentFactory<Object> componentFactory;

  @ViewChild('container', read: ViewContainerRef)
  set viewContainerRef(ViewContainerRef value) {
    if (value != null) {
      _ngZone.runAfterChangesObserved(() {
        value
          ..clear()
          ..createComponent(componentFactory);
        _changeDetectorRef.markForCheck();
      });
    }
  }
}

@Component(
  selector: 'test',
  template: '''
    <on-push-embedded-container [componentFactory]="defaultComponentFactory">
    </on-push-embedded-container>
  ''',
  directives: [OnPushEmbeddedContainerComponent],
)
class LoadInOnPushEmbeddedView {
  static final defaultComponentFactory = ng.DefaultComponentNgFactory;
}

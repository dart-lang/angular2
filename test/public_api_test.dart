@TestOn('browser && !js')
library angular2.test.public_api_test;

import 'dart:mirrors';

import 'package:test/test.dart';

import 'symbol_inspector/symbol_inspector.dart';

// =============================================================================
// =============================================================================
// ============= S T O P   -    S T O P   -  S T O P   -  S T O P  =============
// =============================================================================
// =============================================================================
//
// DO NOT EDIT THIS LIST OF PUBLIC APIS UNLESS YOU GET IT CLEARED BY:
// mhevery, ferhat, or matanl!
//
// =============================================================================
// =============================================================================
var NG_COMMON = [
  'AbstractControl',
  'AbstractControlDirective',
  'AsyncPipe',
  'COMMON_DIRECTIVES',
  'COMMON_PIPES',
  'CORE_DIRECTIVES',
  'CheckboxControlValueAccessor',
  'Control',
  'ControlArray',
  'ControlContainer',
  'ControlGroup',
  'ControlValueAccessor',
  'CurrencyPipe',
  'DatePipe',
  'DecimalPipe',
  'DefaultValueAccessor',
  'FORM_BINDINGS',
  'FORM_DIRECTIVES',
  'FORM_PROVIDERS',
  'Form',
  'FormBuilder',
  'JsonPipe',
  'LowerCasePipe',
  'MaxLengthValidator',
  'MinLengthValidator',
  'NG_ASYNC_VALIDATORS',
  'NG_VALIDATORS',
  'NG_VALUE_ACCESSOR',
  'NgClass',
  'NgControl',
  'NgControlGroup',
  'NgControlName',
  'NgControlStatus',
  'NgFor',
  'NgForm',
  'NgFormControl',
  'NgFormModel',
  'NgIf',
  'NgTemplateOutlet',
  'NgModel',
  'NgSelectOption',
  'NgStyle',
  'NgSwitch',
  'NgSwitchWhen',
  'NgSwitchDefault',
  'NumberPipe',
  'PatternValidator',
  'PercentPipe',
  'ReplacePipe',
  'RequiredValidator',
  'SelectControlValueAccessor',
  'SlicePipe',
  'UpperCasePipe',
  'Validator',
  'ValidatorFn',
  'Validators',
  'RadioButtonState',
];
var NG_COMPILER = [
  'TemplateAst',
  'TemplateAstVisitor',
  'DEFAULT_PACKAGE_URL_PROVIDER',
  'UrlResolver',
  'AttrAst',
  'BoundDirectivePropertyAst',
  'BoundElementPropertyAst',
  'BoundEventAst',
  'HandlerType',
  'BoundTextAst',
  'COMPILER_PROVIDERS',
  'CompileDirectiveMetadata',
  'CompileTemplateMetadata',
  'CompileTypeMetadata',
  'DirectiveAst',
  'ElementAst',
  'ElementProviderUsage',
  'EmbeddedTemplateAst',
  'NgContentAst',
  'PLATFORM_DIRECTIVES',
  'PLATFORM_PIPES',
  'PropertyBindingType',
  'SourceModule',
  'TextAst',
  'VariableAst',
  'ReferenceAst',
  'XHR',
  'templateVisitAll',
  'CompileDiDependencyMetadata',
  'CompileFactoryMetadata',
  'CompileIdentifierMetadata',
  'CompileMetadataWithIdentifier',
  'CompileMetadataWithType',
  'CompilePipeMetadata',
  'CompileProviderMetadata',
  'CompileQueryMetadata',
  'CompileTokenMetadata',
  'CompilerConfig',
  'DirectiveResolver',
  'NormalizedComponentWithViewDirectives',
  'OfflineCompiler',
  'PipeResolver',
  'ProviderAst',
  'ProviderAstType',
  'ViewResolver',
  'createOfflineCompileUrlResolver'
];
var NG_CORE = [
  'APP_INITIALIZER',
  'APP_ID',
  'AngularEntrypoint',
  'AbstractProviderError',
  'ApplicationRef',
  'APPLICATION_COMMON_PROVIDERS',
  'Attribute',
  'Provider',
  'PLATFORM_DIRECTIVES',
  'ChangeDetectionStrategy',
  'ChangeDetectorRef',
  'ComponentResolver',
  'Component',
  'ComponentState',
  'ComponentStateCallback',
  'ComponentRef',
  'ContentChild',
  'ContentChildren',
  'CyclicDependencyError',
  'PLATFORM_PIPES',
  'ReflectiveDependency',
  'DependencyMetadata',
  'Directive',
  'SkipAngularInitCheck',
  'DynamicComponentLoader',
  'ElementRef',
  'Output',
  'EmbeddedViewRef',
  'EventEmitter',
  'ExceptionHandler',
  'ExpressionChangedAfterItHasBeenCheckedException',
  'Host',
  'HostBinding',
  'HostListener',
  'ComponentFactory',
  'Inject',
  'Injectable',
  'Injector',
  'MapInjector',
  'MapInjectorFactory',
  'InjectorFactory',
  'ReflectiveInjector',
  'InstantiationError',
  'InvalidProviderError',
  'ReflectiveKey',
  'NgZone',
  'NgZoneError',
  'NoAnnotationError',
  'NoProviderError',
  'OpaqueToken',
  'Optional',
  'OutOfBoundsError',
  'Pipe',
  'PlatformRef',
  'Input',
  'Query',
  'QueryList',
  'RootRenderer',
  'RenderComponentType',
  'ResolvedReflectiveBinding',
  'ResolvedReflectiveProvider',
  'ResolvedReflectiveFactory',
  'Self',
  'SkipSelf',
  'SimpleChange',
  'TemplateRef',
  'Testability',
  'TestabilityRegistry',
  'GetTestability',
  'PACKAGE_ROOT_URL',
  'View',
  'ViewChild',
  'ViewChildren',
  'ViewContainerRef',
  'ViewEncapsulation',
  'ViewQuery',
  'WrappedException',
  'WrappedValue',
  'provide',
  'createNgZone',
  'coreBootstrap',
  'coreLoadAndBootstrap',
  'createPlatform',
  'disposePlatform',
  'getPlatform',
  'PLATFORM_COMMON_PROVIDERS',
  'PLATFORM_INITIALIZER',
  'AfterContentChecked',
  'AfterContentInit',
  'AfterViewChecked',
  'AfterViewInit',
  'DoCheck',
  'OnChanges',
  'OnDestroy',
  'OnInit',
  'PipeTransform',
  'reflector',
  'Stream',
  'GetterFn',
  'MethodFn',
  'NoReflectionCapabilities',
  'PlatformReflectionCapabilities',
  'ReflectionInfo',
  'Reflector',
  'SetterFn',
  'ViewRef',
  'TrackByFn',
  'noValueProvided',
];
var NG_PLATFORM_BROWSER = [
  'AngularEntrypoint',
  'BROWSER_APP_PROVIDERS',
  'BROWSER_PROVIDERS',
  'BROWSER_SANITIZATION_PROVIDERS',
  'SanitizationService',
  'TemplateSecurityContext',
  'DOCUMENT',
  'bootstrap',
  'browserPlatform',
  'defaultDocumentProvider',
  'disableDebugTools',
  'enableDebugTools',
  'RUNTIME_COMPILER_PROVIDERS'
];
var NG_PLATFORM_BROWSER_TESTING = [
  'inspectNativeElement',
  'By',
  'DebugNode',
  'DebugElement',
  'TEST_BROWSER_APPLICATION_PROVIDERS',
  'TEST_BROWSER_PLATFORM_PROVIDERS',
];
var NG_PLATFORM_COMMON = [
  'APP_BASE_HREF',
  'BrowserPlatformLocation',
  'HashLocationStrategy',
  'Location',
  'LocationStrategy',
  'PathLocationStrategy',
  'PlatformLocation',
  'baseHRefFromDOM',
  'BaseHRefFromDOMProvider',
];

var NG_API = {
var NG_API = <LibraryMirror, List<String>>{
  commonLib: NG_COMMON,
  compilerLib: NG_COMPILER,
  coreLib: NG_CORE,
  platformBrowserLib: NG_PLATFORM_BROWSER,
  platformBrowserTestingLib: NG_PLATFORM_BROWSER_TESTING,
  platformCommonLib: NG_PLATFORM_COMMON,
};

void main() {
  group('Public API check', () {
    for (var lib in NG_API.keys) {
      test('for ${lib} should fail when it changes unexpectedly', () {
        var symbols = getSymbolsFromLibrary(lib);
        var expected = NG_API[lib];
        expect(diff(symbols, expected), isEmpty);
      });
    }
  });
}

List<String> diff(List<String> actual, List<String> expected) => <String>[]
  ..addAll(actual.where((i) => !expected.contains(i)).map((s) => '+$s'))
  ..addAll(expected.where((i) => !actual.contains(i)).map((s) => '-$s'))
  ..sort();

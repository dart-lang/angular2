import 'package:barback/src/asset/asset_id.dart';
import 'package:glob/glob.dart';

import 'annotation_matcher.dart';
import 'mirror_mode.dart';

const CUSTOM_ANNOTATIONS_PARAM = 'custom_annotations';
const ENTRY_POINT_PARAM = 'entry_points';
const FORMAT_CODE_PARAM = 'format_code';
const REFLECT_PROPERTIES_AS_ATTRIBUTES = 'reflect_properties_as_attributes';
const PLATFORM_DIRECTIVES = 'platform_directives';
const PLATFORM_PIPES = 'platform_pipes';
const RESOLVED_IDENTIFIERS = 'resolved_identifiers';
const ERROR_ON_MISSING_IDENTIFIERS = 'error_on_missing_identifiers';
const INIT_REFLECTOR_PARAM = 'init_reflector';
const INLINE_VIEWS_PARAM = 'inline_views';
const MIRROR_MODE_PARAM = 'mirror_mode';
const CODEGEN_MODE_PARAM = 'codegen_mode';
const LAZY_TRANSFORMERS = 'lazy_transformers';
const TRANSLATIONS = 'translations';
const IGNORE_REAL_TEMPLATE_ISSUES_PARAM = 'ignore_real_template_issues';
const USE_LEGACY_STYLE_ENCAPSULATION = 'use_legacy_style_encapsulation';
const USE_ANALYZER = 'use_analyzer';

const CODEGEN_DEBUG_MODE = 'debug';

/// Provides information necessary to transform an Angular2 app.
class TransformerOptions {
  final List<Glob> entryPointGlobs;

  /// The path to the files where the application's calls to `bootstrap` are.
  final List<String> entryPoints;

  /// The `BarbackMode#name` we are running in.
  final String modeName;

  /// The [MirrorMode] to use for the transformation.
  final MirrorMode mirrorMode;

  /// Whether to generate calls to our generated `initReflector` code
  final bool initReflector;

  /// The [AnnotationMatcher] which is used to identify angular annotations.
  final AnnotationMatcher annotationMatcher;

  /// Whether to reflect property values as attributes.
  /// If this is `true`, the change detection code will echo set property values
  /// as attributes on DOM elements, which may aid in application debugging.
  final bool reflectPropertiesAsAttributes;

  /// Whether to generate debug information in views.
  /// Needed for testing and improves error messages when exception are triggered.
  final String codegenMode;

  /// A set of directives that will be automatically passed-in to the template compiler
  /// Format of an item in the list:
  /// angular2/lib/src/common/common_directives.dart#COMMON_DIRECTIVES
  final List<String> platformDirectives;

  /// A set of pipes that will be automatically passed-in to the template compiler
  /// Format of an item in the list:
  /// angular2/lib/src/common/pipes.dart#COMMON_PIPES
  final List<String> platformPipes;

  /// A map of identifier/asset pairs used when resolving identifiers.
  final Map<String, String> resolvedIdentifiers;

  /// when set ot false, the transformer will warn about missing identifiers but not error
  final bool errorOnMissingIdentifiers;

  /// Whether to format generated code.
  /// Code that is only modified will never be formatted because doing so may
  /// invalidate the source maps generated by `dart2js` and/or other tools.
  final bool formatCode;

  /// Whether to inline views.
  /// If this is `true`, the transformer will *only* make a single pass over the
  /// input files and inline `templateUrl` and `styleUrls` values.
  /// This is undocumented, for testing purposes only, and may change or break
  /// at any time.
  final bool inlineViews;

  /// Whether to make transformers lazy.
  /// If this is `true`, and in `debug` mode only, the transformers will be
  /// lazy (will only build assets that are requested).
  /// This is undocumented, for testing purposes only, and may change or break
  /// at any time.
  final bool lazyTransformers;

  /// Whether to generate compiled templates.
  ///
  /// This option is strictly for internal testing and is not available as an
  /// option on the transformer.
  /// Setting this to `false` means that our generated .template.dart files do
  /// not have any compiled templates or change detectors defined in them.
  /// These files will not be usable, but this allows us to test the code output
  /// of the transformer without breaking when compiled template internals
  /// change.
  final bool genCompiledTemplates;

  /// The path to the file with translations.
  final AssetId translations;

  /// Whether to ignore analyzer errors and warnings in generated templates that
  /// are the result of an invalid template.
  final bool ignoreRealTemplateIssues;

  /// Whether to warn about hand-coding the deferred import initialization
  /// logic, instead of relying on the angular2/transform/deferred_rewriter.
  final bool checkDeferredImportInitialization;

  /// Whether to use legacy CSS style encapsulation selectors and behavior. When
  /// [true], shadow host selectors prevent following selectors from being
  /// scoped to their component much like a shadow piercing combinator. It
  /// also allows the use of the following deprecated selectors:
  /// * ::content
  /// * ::shadow
  /// * polyfill-next-selector
  /// * polyfill-unscoped-rule
  final bool useLegacyStyleEncapsulation;

  /// Whether to use the new analyzer-based codegen.
  ///
  /// When [true], this will use the analyzer to resolve types before running
  /// the angular template compiler, resulting in sounder and better performing
  /// code.
  final bool useAnalyzer;

  TransformerOptions._internal(
    this.entryPoints,
    this.entryPointGlobs,
    this.modeName,
    this.mirrorMode,
    this.initReflector,
    this.annotationMatcher, {
    this.formatCode,
    this.codegenMode,
    this.genCompiledTemplates,
    this.inlineViews,
    this.lazyTransformers,
    this.platformDirectives,
    this.platformPipes,
    this.resolvedIdentifiers,
    this.errorOnMissingIdentifiers,
    this.translations,
    this.reflectPropertiesAsAttributes,
    this.ignoreRealTemplateIssues,
    this.checkDeferredImportInitialization,
    this.useLegacyStyleEncapsulation,
    this.useAnalyzer,
  });

  factory TransformerOptions(
    List<String> entryPoints, {
    String modeName: 'release',
    MirrorMode mirrorMode: MirrorMode.none,
    bool initReflector: true,
    List<ClassDescriptor> customAnnotationDescriptors: const [],
    bool inlineViews: false,
    String codegenMode: '',
    bool genCompiledTemplates: true,
    bool reflectPropertiesAsAttributes: false,
    bool errorOnMissingIdentifiers: true,
    List<String> platformDirectives,
    List<String> platformPipes,
    Map<String, String> resolvedIdentifiers,
    bool lazyTransformers: false,
    AssetId translations: null,
    bool formatCode: false,
    bool ignoreRealTemplateIssues: false,
    bool checkDeferredImportInitialization: false,
    bool useLegacyStyleEncapsulation: false,
    bool useAnalyzer: false,
  }) {
    var annotationMatcher = new AnnotationMatcher()
      ..addAll(customAnnotationDescriptors);
    var entryPointGlobs = entryPoints != null
        ? entryPoints.map((path) => new Glob(path)).toList(growable: false)
        : null;
    return new TransformerOptions._internal(
      entryPoints, entryPointGlobs,
      modeName, mirrorMode, initReflector, annotationMatcher,
      codegenMode: codegenMode,
      genCompiledTemplates: genCompiledTemplates,
      reflectPropertiesAsAttributes: reflectPropertiesAsAttributes,
      platformDirectives: platformDirectives,
      platformPipes: platformPipes,
      resolvedIdentifiers: resolvedIdentifiers,
      // TODO(tbosch): remove this from the options once this has landed
      errorOnMissingIdentifiers: true,
      inlineViews: inlineViews,
      lazyTransformers: lazyTransformers,
      translations: translations,
      formatCode: formatCode,
      ignoreRealTemplateIssues: ignoreRealTemplateIssues,
      checkDeferredImportInitialization: checkDeferredImportInitialization,
      useLegacyStyleEncapsulation: useLegacyStyleEncapsulation,
      useAnalyzer: useAnalyzer,
    );
  }
}

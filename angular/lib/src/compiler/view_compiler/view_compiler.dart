import 'package:angular/src/core/change_detection/change_detection.dart'
    show ChangeDetectionStrategy;
import 'package:angular_compiler/angular_compiler.dart';

import 'package:source_span/source_span.dart';
import 'package:logging/logging.dart';

import '../compile_metadata.dart'
    show CompileDirectiveMetadata, CompilePipeMetadata;
import '../expression_parser/parser.dart';
import '../identifiers.dart';
import '../logging.dart';
import '../output/output_ast.dart' as o;
import '../parse_util.dart' show ParseErrorLevel;
import '../schema/element_schema_registry.dart';
import '../style_compiler.dart' show StylesCompileResult;
import '../template_ast.dart' show TemplateAst, templateVisitAll;
import 'compile_element.dart' show CompileElement;
import 'compile_view.dart' show CompileView;
import 'view_binder.dart' show bindView, bindViewHostProperties;
import 'view_builder.dart';
import 'view_compiler_utils.dart' show outlinerDeprecated;

class ViewCompileResult {
  List<o.Statement> statements;
  String viewFactoryVar;
  List<ViewCompileDependency> dependencies;
  ViewCompileResult(this.statements, this.viewFactoryVar, this.dependencies);
}

/// Compiles a single component to a set of CompileView(s) and generates top
/// level statements to support debugging and view factories.
///
/// - Creates main CompileView
/// - Runs ViewBuilderVisitor over template ast nodes
///     - For each embedded template creates a child CompileView and recurses.
/// - Builds a tree of CompileNode/Element(s)
class ViewCompiler {
  final CompilerFlags _genConfig;
  final ElementSchemaRegistry _schemaRegistry;
  Parser parser;
  Logger _logger;

  ViewCompiler(this._genConfig, this.parser, this._schemaRegistry);

  ViewCompileResult compileComponent(
      CompileDirectiveMetadata component,
      List<TemplateAst> template,
      StylesCompileResult stylesCompileResult,
      o.Expression styles,
      List<CompilePipeMetadata> pipes,
      Map<String, String> deferredModules) {
    var statements = <o.Statement>[];
    var dependencies = <ViewCompileDependency>[];
    var view = new CompileView(component, _genConfig, pipes, styles, 0,
        new CompileElement.root(), [], deferredModules);
    buildView(view, template, stylesCompileResult, dependencies);
    // Need to separate binding from creation to be able to refer to
    // variables that have been declared after usage.
    bindView(view, template);
    bindHostProperties(view);
    finishView(view, statements);
    return new ViewCompileResult(
        statements, view.viewFactory.name, dependencies);
  }

  void bindHostProperties(CompileView view) {
    var errorHandler =
        (String message, SourceSpan sourceSpan, [ParseErrorLevel level]) {
      if (level == ParseErrorLevel.FATAL) {
        logger.severe(message);
      } else {
        logger.warning(message);
      }
    };
    bindViewHostProperties(view, parser, _schemaRegistry, errorHandler);
  }

  /// Builds the view and returns number of nested views generated.
  int buildView(
      CompileView view,
      List<TemplateAst> template,
      StylesCompileResult stylesCompileResult,
      List<ViewCompileDependency> targetDependencies) {
    var builderVisitor = new ViewBuilderVisitor(
        view, parser, targetDependencies, stylesCompileResult);
    templateVisitAll(builderVisitor, template,
        view.declarationElement.parent ?? view.declarationElement);
    return builderVisitor.nestedViewCount;
  }

  /// Creates top level statements for main and nested views generated by
  /// buildView.
  void finishView(CompileView view, List<o.Statement> targetStatements) {
    view.afterNodes();
    createViewTopLevelStmts(view, targetStatements);
    int nodeCount = view.nodes.length;
    var nodes = view.nodes;
    for (int i = 0; i < nodeCount; i++) {
      var node = nodes[i];
      if (node is CompileElement && node.embeddedView != null) {
        finishView(node.embeddedView, targetStatements);
      }
    }
  }

  void createViewTopLevelStmts(
      CompileView view, List<o.Statement> targetStatements) {
    o.Expression nodeDebugInfosVar =
        createStaticNodeDebugInfos(view, targetStatements);

    // If we are compiling root view, create a render type for the component.
    // Example: RenderComponentType renderType_MaterialButtonComponent;
    bool creatingMainView = view.viewIndex == 0;

    o.ClassStmt viewClass = createViewClass(view, nodeDebugInfosVar, parser);
    targetStatements.add(viewClass);

    targetStatements.add(createViewFactory(view, viewClass));

    if (creatingMainView &&
        view.component.inputs != null &&
        view.component.changeDetection == ChangeDetectionStrategy.Stateful &&
        outlinerDeprecated) {
      writeInputUpdaters(view, targetStatements);
    }
  }

  /// Create top level node debug info.
  /// Example:
  /// const List<StaticNodeDebugInfo> nodeDebugInfos_MyAppComponent0 = const [
  ///     const StaticNodeDebugInfo(const [],null,const <String, dynamic>{}),
  ///     const StaticNodeDebugInfo(const [],null,const <String, dynamic>{}),
  ///     const StaticNodeDebugInfo(const [
  ///       import1.AcxDarkTheme,
  ///       import2.MaterialButtonComponent,
  ///       import3.ButtonDirective
  ///     ]
  ///     ,import2.MaterialButtonComponent,const <String, dynamic>{}),
  /// const StaticNodeDebugInfo(const [],null,const <String, dynamic>{}),
  o.Expression createStaticNodeDebugInfos(
      CompileView view, List<o.Statement> targetStatements) {
    o.Expression nodeDebugInfosVar = o.NULL_EXPR;
    if (view.genConfig.genDebugInfo) {
      nodeDebugInfosVar = o.variable(
          'nodeDebugInfos_${view.component.type.name}${view.viewIndex}');
      targetStatements.add(((nodeDebugInfosVar as o.ReadVarExpr))
          .set(o.literalArr(
              view.nodes.map(createStaticNodeDebugInfo).toList(),
              new o.ArrayType(
                  new o.ExternalType(Identifiers.StaticNodeDebugInfo))))
          .toDeclStmt());
    }
    return nodeDebugInfosVar;
  }

  bool get genDebugInfo => _genConfig.genDebugInfo;
}

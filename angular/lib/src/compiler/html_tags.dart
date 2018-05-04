class HtmlTagDefinition {
  final closedByChildren = <String, bool>{};
  final requiredParents = <String, bool>{};
  final String implicitNamespacePrefix;
  final bool isVoid;

  String parentToAdd;
  bool closedByParent = false;

  HtmlTagDefinition(
      {List<String> closedByChildren,
      List<String> requiredParents,
      this.implicitNamespacePrefix,
      bool closedByParent,
      bool isVoid})
      : this.isVoid = isVoid == true {
    if (closedByChildren != null && closedByChildren.isNotEmpty) {
      for (var tagName in closedByChildren) {
        this.closedByChildren[tagName] = true;
      }
    }
    this.closedByParent = closedByParent == true || this.isVoid;
    if (requiredParents != null && requiredParents.length > 0) {
      this.parentToAdd = requiredParents[0];
      requiredParents
          .forEach((tagName) => this.requiredParents[tagName] = true);
    }
  }

  bool requireExtraParent(String currentParent) {
    if (this.requiredParents == null) {
      return false;
    }
    if (currentParent == null) {
      return true;
    }
    var lcParent = currentParent.toLowerCase();
    return this.requiredParents[lcParent] != true && lcParent != "template";
  }

  bool isClosedByChild(String name) {
    return this.isVoid || this.closedByChildren[name.toLowerCase()] == true;
  }
}
// see http://www.w3.org/TR/html51/syntax.html#optional-tags

// This implementation does not fully conform to the HTML5 spec.
final _tagDefinitions = <String, HtmlTagDefinition>{
  "base": new HtmlTagDefinition(isVoid: true),
  "meta": new HtmlTagDefinition(isVoid: true),
  "area": new HtmlTagDefinition(isVoid: true),
  "embed": new HtmlTagDefinition(isVoid: true),
  "link": new HtmlTagDefinition(isVoid: true),
  "img": new HtmlTagDefinition(isVoid: true),
  "input": new HtmlTagDefinition(isVoid: true),
  "param": new HtmlTagDefinition(isVoid: true),
  "hr": new HtmlTagDefinition(isVoid: true),
  "br": new HtmlTagDefinition(isVoid: true),
  "source": new HtmlTagDefinition(isVoid: true),
  "track": new HtmlTagDefinition(isVoid: true),
  "wbr": new HtmlTagDefinition(isVoid: true),
  "p": new HtmlTagDefinition(closedByChildren: [
    "address",
    "article",
    "aside",
    "blockquote",
    "div",
    "dl",
    "fieldset",
    "footer",
    "form",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "header",
    "hgroup",
    "hr",
    "main",
    "nav",
    "ol",
    "p",
    "pre",
    "section",
    "table",
    "ul"
  ], closedByParent: true),
  "thead": new HtmlTagDefinition(closedByChildren: ["tbody", "tfoot"]),
  "tbody": new HtmlTagDefinition(
      closedByChildren: ["tbody", "tfoot"], closedByParent: true),
  "tfoot":
      new HtmlTagDefinition(closedByChildren: ["tbody"], closedByParent: true),
  "tr": new HtmlTagDefinition(
      closedByChildren: ["tr"],
      requiredParents: ["tbody", "tfoot", "thead"],
      closedByParent: true),
  "td": new HtmlTagDefinition(
      closedByChildren: ["td", "th"], closedByParent: true),
  "th": new HtmlTagDefinition(
      closedByChildren: ["td", "th"], closedByParent: true),
  "col": new HtmlTagDefinition(requiredParents: ["colgroup"], isVoid: true),
  "svg": new HtmlTagDefinition(implicitNamespacePrefix: "svg"),
  "math": new HtmlTagDefinition(implicitNamespacePrefix: "math"),
  "li": new HtmlTagDefinition(closedByChildren: ["li"], closedByParent: true),
  "dt": new HtmlTagDefinition(closedByChildren: ["dt", "dd"]),
  "dd": new HtmlTagDefinition(
      closedByChildren: ["dt", "dd"], closedByParent: true),
  "rb": new HtmlTagDefinition(
      closedByChildren: ["rb", "rt", "rtc", "rp"], closedByParent: true),
  "rt": new HtmlTagDefinition(
      closedByChildren: ["rb", "rt", "rtc", "rp"], closedByParent: true),
  "rtc": new HtmlTagDefinition(
      closedByChildren: ["rb", "rtc", "rp"], closedByParent: true),
  "rp": new HtmlTagDefinition(
      closedByChildren: ["rb", "rt", "rtc", "rp"], closedByParent: true),
  "optgroup": new HtmlTagDefinition(
      closedByChildren: ["optgroup"], closedByParent: true),
  "option": new HtmlTagDefinition(
      closedByChildren: ["option", "optgroup"], closedByParent: true),
  "style": new HtmlTagDefinition(),
  "script": new HtmlTagDefinition(),
  "title": new HtmlTagDefinition(),
  "textarea": new HtmlTagDefinition()
};
final HtmlTagDefinition _defaultTagDefinition = new HtmlTagDefinition();
HtmlTagDefinition getHtmlTagDefinition(String tagName) {
  var result = _tagDefinitions[tagName.toLowerCase()];
  return result ?? _defaultTagDefinition;
}

final _nsPrefixRegExp = new RegExp(r'^@([^:]+):(.+)');
List<String> splitNsName(String elementName) {
  if (elementName[0] != "@") {
    return [null, elementName];
  }
  var match = _nsPrefixRegExp.firstMatch(elementName);
  return [match[1], match[2]];
}

String mergeNsAndName(String prefix, String localName) {
  return prefix != null ? '@$prefix:$localName' : localName;
}

import Foundation

/// Renders an AST expression to an expression string.
open class ExpressionRenderer: RendererProtocol, VisitorProtocol {
    public init(wildcardString: String) {
        _wildcardString = wildcardString
    }

    public convenience init() {
        self.init(wildcardString: Token.WildcardString)
    }

    /// Render an expression to a string.
    open func render(_ expression: ExpressionProtocol) -> String! {
        return expression.accept(self)
    }

    /// Visit a LogicalAnd node.
    open func visit(_ node: LogicalAnd) -> String! {
        return "(" + implodeNodes("AND", node.children()) + ")"
    }

    /// Visit a LogicalOr node.
    open func visit(_ node: LogicalOr) -> String! {
        return "(" + implodeNodes("OR", node.children()) + ")"
    }

    /// Visit a LogicalNot node.
    open func visit(_ node: LogicalNot) -> String! {
        return "NOT " + node.child().accept(self)
    }

    /// Visit a Tag node.
    open func visit(_ node: Tag) -> String! {
        return escapeString(node.name())
    }

    /// Visit a pattern node.
    open func visit(_ node: Pattern) -> String! {
        var string = ""
        for child in node.children() {
            if let result = child.accept(self) {
                string += result
            } else {
                // A nil result means an error occurred. eg. PatternLiteral contained the wildcard.
                return nil
            }
        }
        return escapeString(string)
    }

    /// Visit a PatternLiteral node.
    open func visit(_ node: PatternLiteral) -> String! {
        if node.string().range(of: _wildcardString, options: NSString.CompareOptions.literal) != nil {
            // Implement a Result<T>/Failable<T> return type.
            // throw Exception "The pattern literal \"" + node.string() + "\" contains the wildcard string \"" + _wildcardString + "\"."
            // fatalError("The pattern literal contains the wildcard string.")
            return nil
        }
        return node.string()
    }

    /// Visit a PatternWildcard node.
    open func visit(_ node: PatternWildcard) -> String! {
        return _wildcardString
    }

    /// Visit a EmptyExpression node.
    open func visit(_ node: EmptyExpression) -> String! {
        return "NOT " + _wildcardString
    }

    fileprivate func implodeNodes(_ separator: String, _ nodes: [ExpressionProtocol]) -> String {
        
        var s: String = ""
        s = nodes.flatMap({$0.accept(self)}).joined(separator: " " + separator + " ")
        return s
        
//        return (" " + separator + " ").join(
//            nodes.map {
//                $0.accept(self)
//            }
//        )
    }

    fileprivate func escapeString(_ string: String) -> String {
        let stringLower = string.lowercased()
        if "and" == stringLower || "or" == stringLower || "not" == stringLower {
            return "\"" + string + "\""
        }

        var escapedString = ""
        let characters: [Character] = ["\\", "(", ")", "\""]
        for char in string {
            if characters.contains(char) {
//            if contains(characters, char) {
                escapedString += "\\" + String(char)
            } else {
                escapedString.append(String(char))
            }
        }

        if string != escapedString || escapedString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines) != nil {
            return "\"" + escapedString + "\""
        }

        return escapedString
    }

    fileprivate let _wildcardString: String
}

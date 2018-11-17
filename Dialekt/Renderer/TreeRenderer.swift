import Foundation

/// Render an AST expression to a string representing the tree structure.
open class TreeRenderer: RendererProtocol, VisitorProtocol {
    public init(endOfLine: String) {
        _endOfLine = endOfLine
    }

    public convenience init() {
        self.init(endOfLine: "\n")
    }

    /// Get the end-of-line string.
    open func endOfLine() -> String {
        return _endOfLine
    }

    /// Render an expression to a string.
    open func render(_ expression: ExpressionProtocol) -> String! {
        return expression.accept(self)
    }

    /// Visit a LogicalAnd node.
    open func visit(_ node: LogicalAnd) -> String {
        return "AND" + _endOfLine + renderChildren(
            node.children().map {
                $0.accept(self)
            }
        )
    }

    /// Visit a LogicalOr node.
    open func visit(_ node: LogicalOr) -> String {
        return "OR" + _endOfLine + renderChildren(
            node.children().map {
                $0.accept(self)
            }
        )
    }

    /// Visit a LogicalNot node.
    open func visit(_ node: LogicalNot) -> String {
        return "NOT" + _endOfLine + indent("- " + node.child().accept(self))
    }

    /// Visit a Tag node.
    open func visit(_ node: Tag) -> String {
        return "TAG " + encodeString(node.name())
    }

    /// Visit a Pattern node.
    open func visit(_ node: Pattern) -> String {
        return "PATTERN" + _endOfLine + renderChildren(
            node.children().map {
                $0.accept(self)
            }
        )
    }

    /// Visit a PatternLiteral node.
    open func visit(_ node: PatternLiteral) -> String {
        return "LITERAL " + encodeString(node.string())
    }

    /// Visit a PatternWildcard node.
    open func visit(_ node: PatternWildcard) -> String {
        return "WILDCARD"
    }

    /// Visit a EmptyExpression node.
    open func visit(_ node: EmptyExpression) -> String {
        return "EMPTY"
    }

    fileprivate func renderChildren(_ children: [String]) -> String {
        var output = ""

        for str in children {
            output += indent("- " + str) + _endOfLine
        }

//        output.substringToIndex
        
//        return output.substringToIndex(
//            advance(output.endIndex, -countElements(_endOfLine))
//        )
        let index = output.index(output.endIndex, offsetBy: -(_endOfLine.characters.count))
        let subText = output.substring(to: index)
        return subText
    }

    fileprivate func indent(_ string: String) -> String {
        return "  " + string.replacingOccurrences(
            of: _endOfLine,
            with: " " + _endOfLine,
            options: NSString.CompareOptions.literal
        )
    }

    fileprivate func encodeString(_ string: String) -> String {
        // Swift/Objective-C json encoding keeps throwing exceptions and requires the string to be inside an Array?
        // I found this solution on Stack Overflow:
        // http://stackoverflow.com/questions/3020094/how-should-i-escape-strings-in-json
        var escapedString = ""
        escapedString += "\""
        for char in string.characters {
            if char == "\\" || char == "\"" {
                escapedString += "\\" + String(char)
            } else if char == "/" {
                escapedString += "\\" + String(char)
            } else if char == "\t" {
                escapedString += "\\t"
            } else if char == "\n" {
                escapedString += "\\n"
            } else if char == "\r" {
                escapedString += "\\r"
            // Swift does not allow this?
            // } else if char == "\b" {
            //    escapedString += "\\b"
            // Swift does not allow this?
            // } else if char == "\f" {
            //    escapedString += "\\f"
            } else {
                escapedString.append(char)
            }
        }
        escapedString += "\""
        return escapedString
    }

    fileprivate let _endOfLine: String
}

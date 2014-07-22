import Foundation

/// Parses a list of tags.
///
/// The expression must be a space-separated list of tags. The result is
/// either EmptyExpression, a single Tag node, or a LogicalAnd node
/// containing only Tag nodes.
public class ListParser: AbstractParser, ParserProtocol {
    /// Parse a list of tags into an array.
    ///
    /// The expression must be a space-separated list of tags. The result is
    /// an array of strings.
    public func parseAsArray(expression: String) -> [String] {
        return parseAsArray(expression, lexer: Lexer())
    }

    /// Parse a list of tags into an array.
    ///
    /// The expression must be a space-separated list of tags. The result is
    /// an array of strings.
    public func parseAsArray(expression: String, lexer: LexerProtocol) -> [String] {
        var tags = [String]()
        let result = parse(expression, lexer: lexer)

        // TODO: might be able to do this with a switch pattern matcher?
//        if result is LogicalAnd {
//            for child in (result as LogicalAnd).children() {
//                tags.append(
//                    (child as Tag).name()
//                )
//            }
//        } else if result is Tag {
//            tags.append(
//                (result as Tag).name()
//            )
//        }
// Can it be done like this?
        if let logicalAndResult as LogicalAnd {
            for child in logicalAndResult.children() {
                tags.append(child.name())
            }
        } else if let tagResult as Tag {
            tags.append(tagResult.name())
        }

        return tags
    }

    internal override func parseExpression() -> ExpressionProtocol {
        let expression = LogicalAnd()

        startExpression()

        while _currentToken {
            expectToken(TokenType.Text)

            if _currentToken!.value.rangeOfString(wildcardString) {
                // TODO: throw "Unexpected wildcard string \"" + this.wildcardString() + "\", in tag \"" + this.currentToken.value + "\"."
				fatalError("Unexpected wildcard string in tag.")
            }

            let tag = Tag(_currentToken!.value)

            startExpression()
            nextToken()
            endExpression(tag)

            expression.add(tag)
        }

        endExpression(expression)

        if expression.children().count == 1 {
            return expression.children()[0]
        }

        return expression
    }
}

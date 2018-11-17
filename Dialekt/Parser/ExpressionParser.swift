open class ExpressionParser: AbstractParser {
    open var logicalOrByDefault = false

    internal override func parseExpression() -> AbstractExpression! {
        startExpression()

        var expression = parseUnaryExpression()
        if expression != nil {
            expression = parseCompoundExpression(expression!)
        }
        if expression == nil {
            return nil
        }

        endExpression(expression!)

        return expression
    }

    fileprivate func parseUnaryExpression() -> AbstractExpression! {
        let foundExpected = expectToken(
            TokenType.text,
            TokenType.logicalNot,
            TokenType.openBracket
        )
        if !foundExpected {
            return nil
        }

        if TokenType.logicalNot == _currentToken.tokenType {
            return parseLogicalNot()
        } else if TokenType.openBracket == _currentToken.tokenType {
            return parseNestedExpression()
        } else if _currentToken.value.range(of: wildcardString, options: NSString.CompareOptions.literal) == nil {
            return parseTag()
        } else {
            return parsePattern()
        }
    }

    fileprivate func parseTag() -> AbstractExpression {
        startExpression()

        let expression = Tag(
            _currentToken.value
        )

        nextToken()

        endExpression(expression)

        return expression
    }

    fileprivate func parsePattern() -> AbstractExpression {
        startExpression()

        // Note:
        // Could not get regex to escape wildcardString correctly for splitting with capture.
        // Using string split for now.
        let parts = _currentToken.value.components(separatedBy: wildcardString)

        let expression = Pattern()

        if _currentToken.value.hasPrefix(wildcardString) {
            expression.add(PatternWildcard())
        }
        var chunks = parts.count - 1
        for value in parts {
            expression.add(PatternLiteral(value))
            if chunks > 1 {
                chunks -= 1
                expression.add(PatternWildcard())
            }
        }
        if _currentToken.value.hasSuffix(wildcardString) {
            expression.add(PatternWildcard())
        }

        nextToken()

        endExpression(expression)

        return expression
    }

    fileprivate func parseNestedExpression() -> AbstractExpression! {
        startExpression()

        nextToken()

        let expression = parseExpression()
        if expression == nil {
            return nil
        }

        let foundExpected = expectToken(TokenType.closeBracket)
        if !foundExpected {
            return nil
        }

        nextToken()

        endExpression(expression!)

        return expression
    }

    fileprivate func parseLogicalNot() -> AbstractExpression {
        startExpression()

        nextToken()

        let expression = LogicalNot(
            parseUnaryExpression()
        )

        endExpression(expression)

        return expression
    }

    fileprivate func parseCompoundExpression(_ expression: ExpressionProtocol, minimumPrecedence: Int = 0) -> AbstractExpression! {
        var leftExpression = expression
        var allowCollapse = false

        while true {
            // Parse the operator and determine whether or not it's explicit ...
            let (oper, isExplicit) = parseOperator()

            let precedence = operatorPrecedence(oper)

            // Abort if the operator's precedence is less than what we're looking for ...
            if precedence < minimumPrecedence {
                break
            }

            // Advance the token pointer if an explicit operator token was found ...
            if isExplicit {
                nextToken()
            }

            // Parse the expression to the right of the operator ...
            var rightExpression = parseUnaryExpression()
            guard rightExpression != nil else {
                return nil
            }

            // Only parse additional compound expressions if their precedence is greater than the
            // expression already being parsed ...
            let (nextOperator, _) = parseOperator()

            if precedence < operatorPrecedence(nextOperator) {
                rightExpression = parseCompoundExpression(rightExpression!, minimumPrecedence: precedence + 1)
                guard rightExpression != nil else {
                    return nil
                }
            }

            // Combine the parsed expression with the existing expression ...
            // Collapse the expression into an existing expression of the same type ...
            if oper == TokenType.logicalAnd {
                if allowCollapse && leftExpression is LogicalAnd {
                    (leftExpression as! LogicalAnd).add(rightExpression!)
                } else {
                    leftExpression = LogicalAnd(leftExpression, rightExpression!)
                    allowCollapse = true
                }
            } else if oper == TokenType.logicalOr {
                if allowCollapse && leftExpression is LogicalOr {
                    (leftExpression as! LogicalOr).add(rightExpression!)
                } else {
                    leftExpression = LogicalOr(leftExpression, rightExpression!)
                    allowCollapse = true
                }
            } else {
                fatalError("Unknown operator type.")
            }
        }

        return leftExpression as! AbstractExpression
    }

    fileprivate func parseOperator() -> (oper: TokenType?, isExplicit: Bool) {
        // End of input ...
        if _currentToken == nil {
            return (nil, false)
        // Closing bracket ...
        } else if TokenType.closeBracket == _currentToken.tokenType {
            return (nil, false)
        // Explicit logical OR ...
        } else if TokenType.logicalOr == _currentToken.tokenType {
            return (TokenType.logicalOr, true)
        // Explicit logical AND ...
        } else if TokenType.logicalAnd == _currentToken.tokenType {
            return (TokenType.logicalAnd, true)
        // Implicit logical OR ...
        } else if logicalOrByDefault {
            return (TokenType.logicalOr, false)
        // Implicit logical AND ...
        } else {
            return (TokenType.logicalAnd, false)
        }
    }

    fileprivate func operatorPrecedence(_ oper: TokenType?) -> Int {
        if oper == TokenType.logicalAnd {
            return 1
        } else if oper == TokenType.logicalOr {
            return 0
        } else {
            return -1
        }
    }
}

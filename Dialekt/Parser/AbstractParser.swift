open class AbstractParser {
    open var wildcardString: String

    public init(_ wildcardString: String) {
        self.wildcardString = wildcardString
        _tokenStack = []
        _tokens = []
        _tokenIndex = 0
    }

    public convenience init() {
        self.init(Token.WildcardString)
    }

    /// Parse an expression.
    open func parse(_ expression: String) -> AbstractExpression! {
        return parse(expression, lexer: Lexer())
    }

    /// Parse an expression using a specific lexer.
    open func parse(_ expression: String, lexer: LexerProtocol) -> AbstractExpression! {
        return parseTokens(
            lexer.lex(expression)
        )
    }

    /// Parse an expression that has already been tokenized.
    open func parseTokens(_ tokens: [Token]) -> AbstractExpression! {
        if (tokens.isEmpty) {
            return EmptyExpression()
        }

        _tokenStack.removeAll()
        _tokens = tokens
        _tokenIndex = 0
        _previousToken = nil
        _currentToken = tokens[0]

        let expression = parseExpression()
        if expression == nil {
            return nil
        }

        if _currentToken != nil {
            // Implement a Result<T>/Failable<T> return type.
            // throw ParseException "Unexpected " + _currentToken.tokenType.description + ", expected end of input."
            // fatalError("Unexpected token, expected end of input.")
            return nil
        }

        return expression
    }

    internal func parseExpression() -> AbstractExpression! {
        assert(false, "This method must be overriden.")
        return nil
    }

    internal func expectToken(_ types: TokenType...) -> Bool {
        if _currentToken == nil {
            // Implement a Result<T>/Failable<T> return type.
            // throw ParseException "Unexpected end of input, expected " + formatExpectedTokenNames(types) + "."
            // fatalError("Unexpected end of input, expected more tokens.")
            return false
        } else if !types.contains(_currentToken.tokenType) {
        //} else if !contains(types, _currentToken.tokenType) {
            // Implement a Result<T>/Failable<T> return type.
            // throw ParseException "Unexpected " + _currentToken.tokenType.description + ", expected " + formatExpectedTokenNames(types) + "."
            // fatalError("Unexpected token, expected other tokens.")
            return false
        }
        return true
    }

    internal func formatExpectedTokenNames(_ types: TokenType...) -> String {
        var result = types[0].description
        var index = 1

        if (types.count > 1) {
            for i in index..<types.count {
                index = i + 1
            //for (; index < types.count; index += 1) {
                result += ", " + types[index].description
            }
        }

        result += " or " + types[index].description

        return result
    }

    /// Advance to the next token.
    internal func nextToken() {
        _previousToken = _currentToken

        _tokenIndex += 1
        
        if _tokenIndex >= _tokens.count {
            _currentToken = nil
        } else {
            _currentToken = _tokens[_tokenIndex]
        }
    }

    /// Record the start of an expression.
    internal func startExpression() {
        _tokenStack.append(_currentToken)
    }

    /// Record the end of an expression.
    internal func endExpression(_ expression: ExpressionProtocol) {
        expression.setTokens(
            _tokenStack.removeLast(),
            _previousToken
        )
    }

    fileprivate var _tokenStack: [Token]
    fileprivate var _tokens: [Token]
    fileprivate var _tokenIndex: Int
    fileprivate var _previousToken: Token!

    internal var _currentToken: Token!
}

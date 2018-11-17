public protocol ParserProtocol {
    func parse(_ expression: String) -> AbstractExpression!
    func parse(_ expression: String, lexer: LexerProtocol) -> AbstractExpression!
    func parseTokens(_ tokens: [Token]) -> AbstractExpression!
}

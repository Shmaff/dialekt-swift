public protocol LexerProtocol {
	/// Tokenize an expression.
	func lex(_ expression: String) -> [Token]!
}

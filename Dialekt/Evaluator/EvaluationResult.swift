/// The overall result of the evaluation of an expression.
open class EvaluationResult {
    public init(
        _ isMatch: Bool,
        _ expressionResults: [ExpressionResult]
    ) {
        _isMatch = isMatch
        _expressionResults = [:]

        for result in expressionResults {
            // Only objects can be hashable, the expression() method returns a protocol.
            _expressionResults[result.expression() as! AbstractExpression] = result
        }
    }

    /// Indicates whether or not the expression matched the tag set.
    open func isMatch() -> Bool {
        return _isMatch
    }

    /// Fetch the result for an individual expression node from the AST.
    open func resultOf(_ expression: ExpressionProtocol) -> ExpressionResult! {
        // Only objects can be hashable, expression is a protocol.
        return _expressionResults[expression as! AbstractExpression]
    }

    fileprivate let _isMatch: Bool
    fileprivate var _expressionResults: [AbstractExpression: ExpressionResult]
}

/// The result for an invidiual expression in the AST.
open class ExpressionResult {
    public init(
        _ expression: ExpressionProtocol,
        _ isMatch: Bool,
        _ matchedTags: [String],
        _ unmatchedTags: [String]
    ) {
        _expression = expression
        _isMatch = isMatch
        _matchedTags = matchedTags
        _unmatchedTags = unmatchedTags
    }

    /// Fetch the expression to which this result applies.
    open func expression() -> ExpressionProtocol {
        return _expression
    }

    /// Indicates whether or not the expression matched the tag set.
    open func isMatch() -> Bool {
        return _isMatch
    }

    /// Fetch the set of tags that matched.
    open func matchedTags() -> [String] {
        return _matchedTags
    }

    /// Fetch set of tags that did not match.
    open func unmatchedTags() -> [String] {
        return _unmatchedTags
    }

    fileprivate let _expression: ExpressionProtocol
    fileprivate let _isMatch: Bool
    fileprivate let _matchedTags: [String]
    fileprivate let _unmatchedTags: [String]
}

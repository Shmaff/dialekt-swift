import Foundation

open class Evaluator: EvaluatorProtocol, ExpressionVisitorProtocol, PatternChildVisitorProtocol {
    public init(caseSensitive: Bool = false, emptyIsWildcard: Bool = false) {
        _caseSensitive = caseSensitive
        _emptyIsWildcard = emptyIsWildcard
    }

    /// Evaluate an expression against a set of tags.
    open func evaluate(_ expression: ExpressionProtocol, tags: [String]) -> EvaluationResult {
        _tags = tags
        _expressionResults.removeAll(keepingCapacity: true)
        
        let result = EvaluationResult(
            expression.accept(self).isMatch(),
            _expressionResults
        )
        
        _tags.removeAll(keepingCapacity: true)
        _expressionResults.removeAll(keepingCapacity: true)

        return result
    }

    /// Visit a LogicalAnd node.
    open func visit(_ node: LogicalAnd) -> ExpressionResult {
        var matchedTags = [String]()
        var isMatch = true

        for n in node.children() {
            let result = n.accept(self)

            if !result.isMatch() {
                isMatch = false
            }
            
            let mt = result.matchedTags()
            for i in 0..<mt.count {
                matchedTags.append(mt[i])
            }
        }

        let unmatchedTags = _tags.filter() {
            !matchedTags.contains($0)
        }

        return createExpressionResult(
            node,
            isMatch: isMatch,
            matchedTags: matchedTags,
            unmatchedTags: unmatchedTags
        )
    }

    /// Visit a LogicalOr node.
    open func visit(_ node: LogicalOr) -> ExpressionResult {
        var matchedTags = [String]()
        var isMatch = false

        for n in node.children() {
            let result = n.accept(self)

            if result.isMatch() {
                isMatch = true
            }

            let mt = result.matchedTags()
            for i in 0..<mt.count {
                matchedTags.append(mt[i])
            }
        }

        let unmatchedTags = _tags.filter() {
            !matchedTags.contains($0)
        }

        return createExpressionResult(
            node,
            isMatch: isMatch,
            matchedTags: matchedTags,
            unmatchedTags: unmatchedTags
        )
    }

    /// Visit a LogicalNot node.
    open func visit(_ node: LogicalNot) -> ExpressionResult {
        let childResult = node.child().accept(self)

        return createExpressionResult(
            node,
            isMatch: !childResult.isMatch(),
            matchedTags: childResult.unmatchedTags(),
            unmatchedTags: childResult.matchedTags()
        )
    }

    /// Visit a Tag node.
    open func visit(_ node: Tag) -> ExpressionResult {
        if _caseSensitive {
            return matchTags(node) {
                return node.name() == $0
            }
        } else {
            return matchTags(node) {
                return node.name().compare($0, options: NSString.CompareOptions.caseInsensitive) == ComparisonResult.orderedSame
            }
        }
    }

    /// Visit a pattern node.
    open func visit(_ node: Pattern) -> ExpressionResult {
        var pattern = "^"

        for n in node.children() {
            pattern += n.accept(self)
        }

        pattern += "$"

        var options = NSString.CompareOptions.regularExpression
        if !_caseSensitive {
            options = [NSString.CompareOptions.regularExpression, NSString.CompareOptions.caseInsensitive]
            //options = NSString.CompareOptions.RegularExpressionSearch | NSString.CompareOptions.CaseInsensitiveSearch
        }

        return matchTags(node) {
            $0.range(of: pattern, options: options) != nil
        }
    }

    /// Visit a PatternLiteral node.
    open func visit(_ node: PatternLiteral) -> String {
        return NSRegularExpression.escapedPattern(for: node.string())
    }
    
    /// Visit a PatternWildcard node.
    open func visit(_ node: PatternWildcard) -> String {
        return ".*"
    }

    /// Visit a EmptyExpression node.
    open func visit(_ node: EmptyExpression) -> ExpressionResult {
        return createExpressionResult(
            node,
            isMatch: _emptyIsWildcard,
            matchedTags: _emptyIsWildcard ? _tags : [String](),
            unmatchedTags: _emptyIsWildcard ? [String]() : _tags
        )
    }

    fileprivate func matchTags(_ expression: ExpressionProtocol, predicate: (_ tag: String) -> Bool) -> ExpressionResult {
        var matchedTags = [String]()
        var unmatchedTags = [String]()

        for tag in _tags {
            if predicate(tag) {
                matchedTags.append(tag)
            } else {
                unmatchedTags.append(tag)
            }
        }

        return createExpressionResult(
            expression,
            isMatch: matchedTags.count > 0,
            matchedTags: matchedTags,
            unmatchedTags: unmatchedTags
        )
    }

    fileprivate func createExpressionResult(_ expression: ExpressionProtocol, isMatch: Bool, matchedTags: [String], unmatchedTags: [String]) -> ExpressionResult {
        let result = ExpressionResult(
            expression,
            isMatch,
            matchedTags,
            unmatchedTags
        )

        _expressionResults.append(result)

        return result
    }

    fileprivate let _caseSensitive: Bool
    fileprivate let _emptyIsWildcard: Bool
    fileprivate var _tags = [String]()
    fileprivate var _expressionResults = [ExpressionResult]()
}

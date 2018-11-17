/// A base class providing common functionality for expressions.
/// Partially implements ExpressionProtocol
open class AbstractExpression: ExpressionProtocol {
    public init() {
        _hashValue = HashSequence.next()
    }

    /// Fetch the first token from the source that is part of this expression.
    open func firstToken() -> Token! {
        return _firstToken
    }

    /// Fetch the last token from the source that is part of this expression.
    open func lastToken() -> Token! {
        return _lastToken
    }

    /// Set the delimiting tokens for this expression.
    open func setTokens(_ firstToken: Token, _ lastToken: Token) {
        _firstToken = firstToken
        _lastToken = lastToken
    }

    // Required to confrom to ExpressionProtocol.
    open func accept<T: VisitorProtocol>(_ visitor: T) -> T.VisitorResultType {
        fatalError("This method must be overriden.")
        return visitor.visit(EmptyExpression()) as T.VisitorResultType
    }

    // Required to confrom to ExpressionProtocol.
    open func accept<T: ExpressionVisitorProtocol>(_ visitor: T) -> T.ExpressionVisitorResultType {
        fatalError("This method must be overriden.")
        return visitor.visit(EmptyExpression())
    }

    fileprivate var _firstToken: Token! = nil
    fileprivate var _lastToken: Token! = nil
    fileprivate var _hashValue: Int = 0

    internal struct HashSequence {
        fileprivate static var _nextHash = 0
        internal static func next() -> Int {
            _nextHash += 1
            return _nextHash
        }
    }
}

/// MARK: Equatable

extension AbstractExpression: Equatable { }

public func ==(lhs: AbstractExpression, rhs: AbstractExpression) -> Bool {
    return lhs === rhs
}

/// MARK: Hashable

extension AbstractExpression: Hashable {
    public var hashValue: Int {
        return self._hashValue
    }
}

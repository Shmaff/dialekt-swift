/// Represents a literal (exact-match) portion of a pattern expression.
open class PatternLiteral: PatternChildProtocol {
    public init(_ string: String) {
        _string = string
    }

    /// Fetch the string to be matched.
    open func string() -> String {
        return _string
    }

    /// Pass this node to the appropriate method on the given visitor.
    open func accept<T: VisitorProtocol>(_ visitor: T) -> T.VisitorResultType {
        return visitor.visit(self) as T.VisitorResultType
    }

    /// Pass this node to the appropriate method on the given visitor.
    open func accept<T: PatternChildVisitorProtocol>(_ visitor: T) -> T.PatternChildVisitorResultType {
        return visitor.visit(self)
    }

    fileprivate let _string: String
}

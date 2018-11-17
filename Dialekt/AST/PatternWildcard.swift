/// Represents the actual wildcard portion of a pattern expression.
open class PatternWildcard: PatternChildProtocol {
    public init() { }

    /// Pass this node to the appropriate method on the given visitor.
    open func accept<T: VisitorProtocol>(_ visitor: T) -> T.VisitorResultType {
        return visitor.visit(self) as T.VisitorResultType
    }

    /// Pass this node to the appropriate method on the given visitor.
    open func accept<T: PatternChildVisitorProtocol>(_ visitor: T) -> T.PatternChildVisitorResultType {
        return visitor.visit(self)
    }
}

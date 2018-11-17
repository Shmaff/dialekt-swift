/// An AST node that represents a literal tag expression.
open class Tag: AbstractExpression {
    public init(_ name: String) {
        _name = name

        super.init()
    }

    /// Fetch the tag name.
    open func name() -> String {
        return _name
    }

    /// Pass this node to the appropriate method on the given visitor.
    open override func accept<T: VisitorProtocol>(_ visitor: T) -> T.VisitorResultType {
        return visitor.visit(self) as T.VisitorResultType
    }

    /// Pass this node to the appropriate method on the given visitor.
    open override func accept<T: ExpressionVisitorProtocol>(_ visitor: T) -> T.ExpressionVisitorResultType {
        return visitor.visit(self)
    }

    fileprivate let _name: String
}

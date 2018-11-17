/// An AST node that represents the logical NOT operator.
open class LogicalNot: AbstractExpression {
    public init(_ child: ExpressionProtocol) {
        _child = child
    }

    /// Fetch the expression being inverted by the NOT operator.
    open func child() -> ExpressionProtocol {
        return _child
    }

    /// Pass this node to the appropriate method on the given visitor.
    open override func accept<T: VisitorProtocol>(_ visitor: T) -> T.VisitorResultType {
        return visitor.visit(self) as T.VisitorResultType
    }

    /// Pass this node to the appropriate method on the given visitor.
    open override func accept<T: ExpressionVisitorProtocol>(_ visitor: T) -> T.ExpressionVisitorResultType {
        return visitor.visit(self)
    }

    fileprivate let _child: ExpressionProtocol
}

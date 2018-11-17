/// An AST node that represents an empty expression.
open class EmptyExpression: AbstractExpression {
    /// Pass this node to the appropriate method on the given visitor.
    open override func accept<T: VisitorProtocol>(_ visitor: T) -> T.VisitorResultType {
        return visitor.visit(self) as T.VisitorResultType
    }

    /// Pass this node to the appropriate method on the given visitor.
    open override func accept<T: ExpressionVisitorProtocol>(_ visitor: T) -> T.ExpressionVisitorResultType {
        return visitor.visit(self)
    }
}

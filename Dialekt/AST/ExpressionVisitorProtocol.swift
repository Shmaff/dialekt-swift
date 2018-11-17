/// Protocol for expression visitors.
public protocol ExpressionVisitorProtocol {
    associatedtype ExpressionVisitorResultType

    /// Visit a LogicalAnd node.
    func visit(_ node: LogicalAnd) -> ExpressionVisitorResultType

    /// Visit a LogicalOr node.
    func visit(_ node: LogicalOr) -> ExpressionVisitorResultType

    /// Visit a LogicalNot node.
    func visit(_ node: LogicalNot) -> ExpressionVisitorResultType

    /// Visit a Tag node.
    func visit(_ node: Tag) -> ExpressionVisitorResultType

    /// Visit a pattern node.
    func visit(_ node: Pattern) -> ExpressionVisitorResultType

    /// Visit a EmptyExpression node.
    func visit(_ node: EmptyExpression) -> ExpressionVisitorResultType
}

/// Protocol for node visitors.
public protocol VisitorProtocol: ExpressionVisitorProtocol, PatternChildVisitorProtocol {
    associatedtype VisitorResultType

    /// Visit a LogicalAnd node.
    func visit(_ node: LogicalAnd) -> VisitorResultType

    /// Visit a LogicalOr node.
    func visit(_ node: LogicalOr) -> VisitorResultType

    /// Visit a LogicalNot node.
    func visit(_ node: LogicalNot) -> VisitorResultType

    /// Visit a Tag node.
    func visit(_ node: Tag) -> VisitorResultType

    /// Visit a pattern node.
    func visit(_ node: Pattern) -> VisitorResultType

    /// Visit a EmptyExpression node.
    func visit(_ node: EmptyExpression) -> VisitorResultType

    /// Visit a PatternLiteral node.
    func visit(_ node: PatternLiteral) -> VisitorResultType

    /// Visit a PatternWildcard node.
    func visit(_ node: PatternWildcard) -> VisitorResultType
}

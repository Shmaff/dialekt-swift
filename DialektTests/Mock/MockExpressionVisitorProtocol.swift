import Dialekt

class MockExpressionVisitorProtocol: ExpressionVisitorProtocol {
    func visit(_ node: LogicalAnd) -> String {
        return "<ExpressionVisitorProtocol visit result: LogicalAnd>"
    }

    func visit(_ node: LogicalOr) -> String {
        return "<ExpressionVisitorProtocol visit result: LogicalOr>"
    }

    func visit(_ node: LogicalNot) -> String {
        return "<ExpressionVisitorProtocol visit result: LogicalNot>"
    }

    func visit(_ node: Tag) -> String {
        return "<ExpressionVisitorProtocol visit result: Tag>"
    }

    func visit(_ node: Dialekt.Pattern) -> String {
        return "<ExpressionVisitorProtocol visit result: Pattern>"
    }

    func visit(_ node: EmptyExpression) -> String {
        return "<ExpressionVisitorProtocol visit result: EmptyExpression>"
    }
}

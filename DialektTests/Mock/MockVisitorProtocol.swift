import Dialekt

class MockVisitorProtocol: VisitorProtocol {
    func visit(_ node: LogicalAnd) -> String {
        return "<VisitorProtocol visit result: LogicalAnd>"
    }

    func visit(_ node: LogicalOr) -> String {
        return "<VisitorProtocol visit result: LogicalOr>"
    }

    func visit(_ node: LogicalNot) -> String {
        return "<VisitorProtocol visit result: LogicalNot>"
    }

    func visit(_ node: Tag) -> String {
        return "<VisitorProtocol visit result: Tag>"
    }

    func visit(_ node: Dialekt.Pattern) -> String {
        return "<VisitorProtocol visit result: Pattern>"
    }

    func visit(_ node: EmptyExpression) -> String {
        return "<VisitorProtocol visit result: EmptyExpression>"
    }

    func visit(_ node: PatternLiteral) -> String {
        return "<VisitorProtocol visit result: PatternLiteral>"
    }

    func visit(_ node: PatternWildcard) -> String {
        return "<VisitorProtocol visit result: PatternWildcard>"
    }
}

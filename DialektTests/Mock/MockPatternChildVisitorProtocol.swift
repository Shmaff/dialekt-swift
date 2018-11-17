import Dialekt

class MockPatternChildVisitorProtocol: PatternChildVisitorProtocol {
    func visit(_ node: PatternLiteral) -> String {
        return "<PatternChildVisitorProtocol visit result: PatternLiteral>"
    }

    func visit(_ node: PatternWildcard) -> String {
        return "<PatternChildVisitorProtocol visit result: PatternWildcard>"
    }
}

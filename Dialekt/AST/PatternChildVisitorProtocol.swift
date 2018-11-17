/// Protocol for pattern child visitors.
public protocol PatternChildVisitorProtocol {
    associatedtype PatternChildVisitorResultType

    /// Visit a PatternLiteral node.
    func visit(_ node: PatternLiteral) -> PatternChildVisitorResultType

    /// Visit a PatternWildcard node.
    func visit(_ node: PatternWildcard) -> PatternChildVisitorResultType
}

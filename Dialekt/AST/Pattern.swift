/// An AST node that represents a pattern-match expression.
open class Pattern: AbstractExpression {
    public init(_ children: [PatternChildProtocol]) {
        _children = children

        super.init()
    }

    public convenience init(_ children: PatternChildProtocol...) {
        self.init(children)
    }

    /// Add a child to this node.
    open func add(_ node: PatternChildProtocol) {
        _children.append(node)
    }

    /// Fetch an array of this node's children.
    open func children() -> [PatternChildProtocol] {
        return _children
    }

    /// Pass this node to the appropriate method on the given visitor.
    open override func accept<T: VisitorProtocol>(_ visitor: T) -> T.VisitorResultType {
        return visitor.visit(self) as T.VisitorResultType
    }

    /// Pass this node to the appropriate method on the given visitor.
    open override func accept<T: ExpressionVisitorProtocol>(_ visitor: T) -> T.ExpressionVisitorResultType {
        return visitor.visit(self)
    }

    fileprivate var _children: [PatternChildProtocol]
}

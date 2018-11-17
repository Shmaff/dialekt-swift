/// A base class providing common functionality for polyadic operators.
open class AbstractPolyadicExpression: AbstractExpression {
    public init(_ children: [ExpressionProtocol]) {
        _children = children

        super.init()
    }

    public convenience init(_ children: ExpressionProtocol...) {
        self.init(children)
    }

    /// Add a child expression to this operator.
    open func add(_ expression: ExpressionProtocol) {
        _children.append(expression)
    }

    /// Fetch an array of this operator's children.
    open func children() -> [ExpressionProtocol] {
        return _children
    }

    fileprivate var _children: [ExpressionProtocol]
}

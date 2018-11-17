/// An AST node.
public protocol NodeProtocol {
    /// Pass this node to the appropriate method on the given visitor.
    func accept<T: VisitorProtocol>(_ visitor: T) -> T.VisitorResultType
}

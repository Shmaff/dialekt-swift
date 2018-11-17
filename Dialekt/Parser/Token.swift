public enum TokenType: Int, CustomStringConvertible {
    case logicalAnd
    case logicalOr
    case logicalNot
    case text
    case openBracket
    case closeBracket

    public var description: String {
        switch self {
        case .logicalAnd:
            return "AND operator"
        case .logicalOr:
            return "OR operator"
        case .logicalNot:
            return "NOT operator"
        case .openBracket:
            return "open bracket"
        case .closeBracket:
            return "close bracket"
        case .text:
            return "tag"
        }
    }
}

open class Token {
    open class var WildcardString: String {
        return "*"
    }

    public init(
        _ type: TokenType,
        _ value: String,
        _ startOffset: Int,
        _ endOffset: Int,
        _ lineNumber: Int,
        _ columnNumber: Int
    ) {
        self.tokenType = type
        self.value = value
        self.startOffset = startOffset
        self.endOffset = endOffset
        self.lineNumber = lineNumber
        self.columnNumber = columnNumber
    }
    
    open var tokenType: TokenType
    open var value: String
    open var startOffset: Int
    open var endOffset: Int
    open var lineNumber: Int
    open var columnNumber: Int
}

// MARK: Equatable

extension Token: Equatable { }

public func ==(lhs: Token, rhs: Token) -> Bool {
    return lhs.tokenType == rhs.tokenType
        && lhs.value == rhs.value
        && lhs.startOffset == rhs.startOffset
        && lhs.endOffset == rhs.endOffset
        && lhs.lineNumber == rhs.lineNumber
        && lhs.columnNumber == rhs.columnNumber
}

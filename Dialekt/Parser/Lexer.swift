import Foundation

open class Lexer: LexerProtocol {
    public init() {
        _currentOffset = 0
        _currentLine = 1
        _currentColumn = 0
        _state = .begin
        _tokens = []
        _nextToken = nil
        _buffer = ""
    }

    /// Tokenize an expression.
    open func lex(_ expression: String) -> [Token]! {
		_currentOffset = 0
		_currentLine = 1
		_currentColumn = 0
		_state = .begin
		_tokens = []
		_nextToken = nil
		_buffer = ""

		var currentChar: Character = "\0"
		var previousChar: Character = "\0"

        for unicodeScalar in expression.unicodeScalars {
            currentChar = Character(unicodeScalar)

            _currentColumn += 1

            if "\n" == previousChar || ("\r" == previousChar && "\n" != currentChar) {
                _currentLine += 1
                _currentColumn = 1
            }

            switch _state {
            case .simpleString:
                handleSimpleStringState(currentChar)
            case .quotedString:
                handleQuotedStringState(currentChar)
            case .quotedStringEscape:
                handleQuotedStringEscapeState(currentChar)
            case .begin:
                handleBeginState(currentChar)
            }

            _currentOffset += 1
            previousChar = currentChar
        }

        if _state == State.simpleString {
            finalizeSimpleString()
        } else if _state == State.quotedString {
            // Implement a Result<T>/Failable<T> return type.
            // throw ParseException "Expected closing quote."
            // fatalError("Expected closing quote.")
            return nil
        } else if _state == State.quotedStringEscape {
            // Implement a Result<T>/Failable<T> return type.
            // throw ParseException "Expected character after backslash."
            // fatalError("Expected character after backslash.")
            return nil
        }

        return _tokens
    }

    fileprivate func handleBeginState(_ currentChar: Character) {
        if characterIsWhitespace(currentChar) {
            // ignore ...
        } else if currentChar == "(" {
            startToken(TokenType.openBracket)
            endToken(currentChar)
        } else if currentChar == ")" {
            startToken(TokenType.closeBracket)
            endToken(currentChar)
        } else if currentChar == "\"" {
            startToken(TokenType.text)
            _state = State.quotedString
        } else {
            startToken(TokenType.text)
            _state = State.simpleString
            _buffer = String(currentChar)
        }
    }

    fileprivate func handleSimpleStringState(_ currentChar: Character) {
        if characterIsWhitespace(currentChar) {
            finalizeSimpleString()
        } else if currentChar == "(" {
            finalizeSimpleString()
            startToken(TokenType.openBracket)
            endToken(currentChar)
        } else if currentChar == ")" {
            finalizeSimpleString()
            startToken(TokenType.closeBracket)
            endToken(currentChar)
        } else {
            _buffer.append(currentChar)
        }
    }

    fileprivate func handleQuotedStringState(_ currentChar: Character) {
        if currentChar == "\\" {
            _state = State.quotedStringEscape
        } else if currentChar == "\"" {
            endToken(_buffer)
            _state = State.begin
            _buffer = ""
        } else {
            _buffer.append(currentChar)
        }
    }

    fileprivate func handleQuotedStringEscapeState(_ currentChar: Character) {
        _state = .quotedString
        _buffer.append(currentChar)
    }

    fileprivate func finalizeSimpleString() {
        let bufferLowercase = _buffer.lowercased()
        if bufferLowercase == "and" {
            _nextToken!.tokenType = TokenType.logicalAnd
        } else if bufferLowercase == "or" {
            _nextToken!.tokenType = TokenType.logicalOr
        } else if bufferLowercase == "not" {
            _nextToken!.tokenType = TokenType.logicalNot
        }

        endToken(_buffer, lengthAdjustment: -1)
        _state = State.begin
        _buffer = ""
    }

    fileprivate func startToken(_ type: TokenType) {
        _nextToken = Token(
            type,
            "",
            _currentOffset,
            0,
            _currentLine,
            _currentColumn
        )
    }

    fileprivate func endToken(_ value: String, lengthAdjustment: Int) {
        _nextToken!.value = value
        _nextToken!.endOffset = _currentOffset + lengthAdjustment + 1
        _tokens.append(_nextToken!)
        _nextToken = nil
    }

    fileprivate func endToken(_ value: String) {
        endToken(value, lengthAdjustment: 0)
    }

    fileprivate func endToken(_ value: Character) {
        endToken(String(value), lengthAdjustment: 0)
    }

	fileprivate enum State {
        case begin
        case simpleString
        case quotedString
        case quotedStringEscape
	}

    fileprivate func characterIsWhitespace(_ character: Character) -> Bool {
        let result = String(character).trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
        return result.isEmpty
    }

    fileprivate var _currentOffset: Int
    fileprivate var _currentLine: Int
    fileprivate var _currentColumn: Int
    fileprivate var _state: State
    fileprivate var _tokens: [Token]
    fileprivate var _nextToken: Token?
    fileprivate var _buffer: String
}

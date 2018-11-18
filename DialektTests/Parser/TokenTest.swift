import XCTest
import Dialekt

class TokenTest: XCTestCase {

    func testConstructor() {
        let token = Token(
            TokenType.text,
            "foo",
            1,
            2,
            3,
            4
        )

        XCTAssertEqual(TokenType.text, token.tokenType)
        XCTAssertEqual("foo", token.value)
        XCTAssertEqual(1, token.startOffset)
        XCTAssertEqual(2, token.endOffset)
        XCTAssertEqual(3, token.lineNumber)
        XCTAssertEqual(4, token.columnNumber)
    }

    func testTypeDescription() {
        for testVector in self.descriptionTestVectors() {
            XCTAssertEqual(testVector.description, testVector.tokenType.description)
        }
    }

    func descriptionTestVectors() -> [DescriptionTestVector] {
        return [
            DescriptionTestVector(
                tokenType: .logicalAnd,
                description: "AND operator"
            ),
            DescriptionTestVector(
                tokenType: .logicalOr,
                description: "OR operator"
            ),
            DescriptionTestVector(
                tokenType: .logicalNot,
                description: "NOT operator"
            ),
            DescriptionTestVector(
                tokenType: .text,
                description: "tag"
            ),
            DescriptionTestVector(
                tokenType: .openBracket,
                description: "open bracket"
            ),
            DescriptionTestVector(
                tokenType: .closeBracket,
                description: "close bracket"
            )
        ]
    }

    class DescriptionTestVector {
        var tokenType: TokenType
        var description: String

        init(tokenType: TokenType, description: String) {
            self.tokenType = tokenType
            self.description = description
        }
    }
}

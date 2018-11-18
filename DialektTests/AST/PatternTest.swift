import XCTest
import Dialekt

class PatternTest: XCTestCase {

    let expression = Dialekt.Pattern()
    let mockVisitor = MockVisitorProtocol()
    let mockExpressionVisitor = MockExpressionVisitorProtocol()

    func testInit() {
        let test = Dialekt.Pattern(
            [
                PatternLiteral("foo"),
                PatternWildcard(),
                PatternLiteral("bar")
            ]
        )
        
        XCTAssertEqual(3, test.children().count)
    }

    func testConvienceInit() {
        let test = Dialekt.Pattern(
            PatternLiteral("foo"),
            PatternWildcard(),
            PatternLiteral("bar")
        )
        
        XCTAssertEqual(3, test.children().count)
    }

    func testDefaults() {
        XCTAssertTrue(self.expression.children().isEmpty)
    }

    func testPerformanceDefaults() {
        self.measure() {
            _ = self.expression.children().isEmpty
        }
    }

    func testAdd() {
        self.expression.add(PatternLiteral("bar"))

        XCTAssertEqual(1, self.expression.children().count)

        if let child = self.expression.children().first as? PatternLiteral {
            XCTAssertEqual("bar", child.string())
        } else {
            XCTAssertTrue(false, "Expected child to be a PatternLiteral")
        }
    }

    func testPerformanceAdd() {
        let child = PatternLiteral("bar")
        self.measure() {
            self.expression.add(child)
        }
    }

    func testAcceptVisitorProtocol() {
        XCTAssertEqual(
            "<VisitorProtocol visit result: Pattern>",
            self.expression.accept(self.mockVisitor)
        )
    }

    func testPerformanceAcceptVisitorProtocol() {
        self.measure() {
            _ = self.expression.accept(self.mockVisitor)
        }
    }

    func testAcceptExpressionVisitorProtocol() {
        XCTAssertEqual(
            "<ExpressionVisitorProtocol visit result: Pattern>",
            self.expression.accept(self.mockExpressionVisitor)
        )
    }

    func testPerformanceAcceptExpressionVisitorProtocol() {
        self.measure() {
            _ = self.expression.accept(self.mockExpressionVisitor)
        }
    }
}

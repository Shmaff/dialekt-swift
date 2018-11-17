import XCTest
import Dialekt

class PatternLiteralTest: XCTestCase {

    let node = PatternLiteral("foo")
    let mockVisitor = MockVisitorProtocol()
    let mockPatternChildVisitor = MockPatternChildVisitorProtocol()

    func testString() {
        XCTAssertEqual("foo", self.node.string())
    }

    func testPerformanceString() {
        self.measure() {
            let string = self.node.string()
        }
    }

    func testAcceptVisitorProtocol() {
        XCTAssertEqual(
            "<VisitorProtocol visit result: PatternLiteral>",
            self.node.accept(self.mockVisitor)
        )
    }

    func testPerformanceAcceptVisitorProtocol() {
        self.measure() {
            let result = self.node.accept(self.mockVisitor)
        }
    }

    func testAcceptPatternChildVisitorProtocol() {
        XCTAssertEqual(
            "<PatternChildVisitorProtocol visit result: PatternLiteral>",
            self.node.accept(self.mockPatternChildVisitor)
        )
    }

    func testPerformanceAcceptPatternChildVisitorProtocol() {
        self.measure() {
            let result = self.node.accept(self.mockPatternChildVisitor)
        }
    }
}

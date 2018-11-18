import XCTest
import Dialekt

class AbstractPolyadicExpressionTest: XCTestCase {

    var node = AbstractPolyadicExpression()

    func testInit() {
        let test = AbstractPolyadicExpression(
            [
                EmptyExpression(),
                EmptyExpression(),
                EmptyExpression()
            ]
        )

        XCTAssertEqual(3, test.children().count)
    }

    func testConvienceInit() {
        let test = AbstractPolyadicExpression(
            EmptyExpression(),
            EmptyExpression(),
            EmptyExpression()
        )

        XCTAssertEqual(3, test.children().count)
    }

    func testDefaults() {
        XCTAssertTrue(self.node.children().isEmpty)
    }

    func testPerformanceDefaults() {
        self.measure() {
            _ = self.node.children().isEmpty
        }
    }

    func testAdd() {
        let emptyExpression = EmptyExpression()
        self.node.add(emptyExpression)

        XCTAssertEqual(1, self.node.children().count)
    }

    func testPerformanceAdd() {
        let emptyExpression = EmptyExpression()

        self.measure() {
            self.node.add(emptyExpression)
        }
    }
}

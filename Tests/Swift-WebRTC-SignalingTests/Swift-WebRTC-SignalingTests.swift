import XCTest
@testable import Swift-WebRTC-Signaling

class Swift-WebRTC-Signaling: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Swift-WebRTC-Signaling().text, "Hello, World!")
    }

    static var allTests : [(String, (Swift-WebRTC-Signaling) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}

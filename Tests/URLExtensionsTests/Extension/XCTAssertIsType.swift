import XCTest

@inlinable public func XCTAssertIsType<V, T>(_ expression1: @autoclosure () -> V, _ expression2: @autoclosure () -> T.Type, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    let resolvedValue = expression1()
    guard let _ = resolvedValue as? T else {
        XCTFail("XCTAssertIsType failed: (\"\(V.self)\") is not equal to (\"\(T.self)\")")
        return
    }
}

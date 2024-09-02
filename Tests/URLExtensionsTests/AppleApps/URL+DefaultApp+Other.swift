import XCTest
@testable import URLExtensions

final class URL_DefaultApp_Other: XCTestCase {
    func testBooks() throws {
        let url = try XCTUnwrap(URL(string: "ibooks://"))
        
        XCTAssertIsType(url.app(), URL.Books.self)
    }
    
    func testCalendar() throws {
        let url = try XCTUnwrap(URL(string: "calshow://"))
        
        XCTAssertIsType(url.app(), URL.Calendar.self)
    }
    
    func testCalculator() throws {
        let url = try XCTUnwrap(URL(string: "calc://"))
        
        XCTAssertIsType(url.app(), URL.Calculator.self)
    }
    
    func testCamera() throws {
        let url = try XCTUnwrap(URL(string: "camera://"))
        
        XCTAssertIsType(url.app(), URL.Camera.self)
    }
    
    func testContacts() throws {
        let url = try XCTUnwrap(URL(string: "contact://"))
        
        XCTAssertIsType(url.app(), URL.Contacts.self)
    }
    
    func testFiles() throws {
        let url = try XCTUnwrap(URL(string: "shareddocuments://"))
        
        XCTAssertIsType(url.app(), URL.Files.self)
    }
    
    func testFreeform() throws {
        let url = try XCTUnwrap(URL(string: "freeform://"))
        
        XCTAssertIsType(url.app(), URL.Freeform.self)
    }
    
    func testNotes() throws {
        let url = try XCTUnwrap(URL(string: "mobilenotes://"))
        
        XCTAssertIsType(url.app(), URL.Notes.self)
    }
    
    func testReminders() throws {
        let url = try XCTUnwrap(URL(string: "x-apple-reminder://"))
        
        XCTAssertIsType(url.app(), URL.Reminders.self)
    }
    
    func testStocks() throws {
        let url = try XCTUnwrap(URL(string: "stocks://"))
        
        XCTAssertIsType(url.app(), URL.Stocks.self)
    }
}

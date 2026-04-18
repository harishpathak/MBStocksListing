//
//  MBStockTrackerUITests.swift
//  MBStockTrackerUITests
//
//  Created by Harish on 15/04/2026.
//

import XCTest

final class MBStockTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testPostiveFlow() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.staticTexts["Start"].firstMatch.tap()
        app.cells.containing(.staticText, identifier: "AAPL").firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Stop"]/*[[".buttons",".containing(.image, identifier: \"stop.fill\")",".containing(.staticText, identifier: \"Stop\")",".otherElements[\"dPo-Zy-Htn\"].buttons",".otherElements.buttons[\"Stop\"]",".buttons[\"Stop\"]"],[[[-1,5],[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".navigationBars",".buttons",".buttons[\"Top 25 US Stocks\"]",".buttons[\"BackButton\"]"],[[[-1,3],[-1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}

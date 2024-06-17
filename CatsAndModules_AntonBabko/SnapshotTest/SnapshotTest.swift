//
//  SnapshotTest.swift
//  SnapshotTest
//
//  Created by admin on 16.06.2024.
//

import XCTest

final class SnapshotTest: XCTestCase {
    
    @MainActor override class func setUp() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    @MainActor func testScreenshots() {
        let app = XCUIApplication()
        
        let alert = app.alerts["myAlert"]
        let button = alert.buttons["Continue"]
        
        if button.waitForExistence(timeout: 10) {
            button.tap()
        }
        sleep(2)
        
        XCUIDevice.shared.orientation = .portrait
        
        snapshot("AntonBabko-MainScreen")
        
        sleep(5)
        
        let firstCell = app.tables.element(boundBy: 0).cells.element(boundBy: 0)
        firstCell.tap()
                        
        snapshot("AntonBabko-DetailsScreen")
    }
    
}

//
//  MyGoalUITests.swift
//  MyGoalUITests
//
//  Created by OLEKSANDR SEMENIUK on 7/25/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import XCTest

class MyGoalUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testCreateHabit() {
        
        let app = XCUIApplication()
        
        var count = app.tables.cells.count
        app.navigationBars.element(boundBy: 0).buttons["Add"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["Choose category"].tap()
        app.tables.cells.element(boundBy: 3).tap()
        
        let textFieldName = elementsQuery.textFields["Habit name"]
        textFieldName.tap()
        textFieldName.setText(text: "test create habit", application: app)
        app.typeText("\r")
        XCTAssertEqual(textFieldName.value as! String, "test create habit")
        
        let textFieldQuestion = elementsQuery.textFields["Habit question"]
        textFieldQuestion.tap()
        textFieldQuestion.setText(text: "question", application: app)
        app.typeText("\r")
        XCTAssertEqual(textFieldQuestion.value as! String, "question")
        
        let saveButton = elementsQuery.buttons["Save"]
        saveButton.tap()
        
        count += 1
        XCTAssertEqual(count, app.tables.cells.count)
        
        self.testDeleteAllHabits()
        
    }
    
    func testDeleteAllHabits() {
        
        let app = XCUIApplication()
        let table = app.tables
        
        while table.cells.count > 0 {
            var count = table.cells.count
            
            let cell = table.cells.element(boundBy: 0)
            cell.swipeLeft()
            cell.buttons.element(boundBy: 0).tap()
            
            count -= 1
            XCTAssertEqual(table.cells.count, count)
        }
    }
    
    func testEditNotificationTime() {
        
        let app = XCUIApplication()
        
        //create habit
        var count = app.tables.cells.count
        app.navigationBars.element(boundBy: 0).buttons["Add"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["Choose category"].tap()
        app.tables.cells.element(boundBy: 2).tap()
        
        let textFieldName = elementsQuery.textFields["Habit name"]
        textFieldName.tap()
        textFieldName.setText(text: "edit time test", application: app)
        app.typeText("\r")
        XCTAssertEqual(textFieldName.value as! String, "edit time test")
        
        let textFieldQuestion = elementsQuery.textFields["Habit question"]
        textFieldQuestion.tap()
        textFieldQuestion.setText(text: "question", application: app)
        app.typeText("\r")
        XCTAssertEqual(textFieldQuestion.value as! String, "question")
        
        let saveButton = elementsQuery.buttons["Save"]
        saveButton.tap()
        
        count += 1
        XCTAssertEqual(count, app.tables.cells.count)
        
        //edit notification time
        let table = app.tables
        let cell = table.staticTexts["edit time test"]
        cell.tap()
        
        elementsQuery.buttons["icon edit"].tap()
        
        let datePickersQuery = app.datePickers
        datePickersQuery.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "6")
        datePickersQuery.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        let engLocale = datePickersQuery.pickerWheels.element(boundBy: 2)
        
        if engLocale.exists {
            engLocale.adjust(toPickerWheelValue: "AM")
        }
        elementsQuery.staticTexts["question"].tap()
        
        let yesButton = elementsQuery.buttons["Yes"]
        yesButton.tap()
        cell.tap()
        
        let textField = elementsQuery.textFields["Push time"]
        XCTAssertEqual(textField.value as! String, "06:00")
        
        yesButton.tap()
        
        self.testDeleteAllHabits()
        
    }
    
}


extension XCUIElement {
    // The following is a workaround for inputting text in the
    //simulator when the keyboard is hidden
    func setText(text: String, application: XCUIApplication) {
        UIPasteboard.general.string = text
        doubleTap()
        application.menuItems.element(boundBy: 0).tap()
    }
}

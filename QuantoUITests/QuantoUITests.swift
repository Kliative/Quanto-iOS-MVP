//
//  QuantoUITests.swift
//  QuantoUITests
//
//  Created by Tawanda Kanyangarara on 13/04/2017.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import XCTest
import UIKit

class QuantoUITests: XCTestCase {
    
    let app = XCUIApplication()
//    let mainVC = MainVC()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this
        
        let baseCountry = "South Africa"
        let baseCity = "Johannesburg"
        
        let destCountry = "Italy"
        let destCity = "Rome"
        
        
        setupApp(baseCountry:baseCountry,baseCity:baseCity,destCountry:destCountry,destCity:destCity)
       

        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSwipeReCalcDecimal() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        app.buttons["2"].tap()
        app.buttons["5"].tap()
        app.buttons["."].tap()
        app.buttons["5"].tap()
        app.buttons["0"].tap()
        
        
        let element = XCUIApplication().otherElements.containing(.button, identifier:"Comparison").children(matching: .other).element(boundBy: 0)
        element.swipeRight()
        
        app.buttons["2"].tap()
        app.buttons["."].tap()
        app.buttons["8"].tap()
        app.buttons["0"].tap()
    }
    
    func testCalculatorWithClose(){
        app.buttons["2"].tap()
        app.buttons["5"].tap()
        app.buttons["."].tap()
        app.buttons["5"].tap()
        app.buttons["0"].tap()
        
        app.buttons["close"].tap()
        
    }
    
    func testCalcShow(){
        app.buttons["close"].tap()
        app.otherElements.containing(.button, identifier:"Comparison").children(matching: .other).element(boundBy: 0).children(matching: .staticText).matching(identifier: "0").element(boundBy: 1).tap()
        
    }
    
    func testNewCountrySel(){
        
        let baseCountry = "Greece"
        let baseCity = "Athens"
        
        let destCountry = "Germany"
        let destCity = "Berlin"
        
        newCountry(baseCountry:baseCountry,baseCity:baseCity,destCountry:destCountry,destCity:destCity)
    }
    func testNewCity() {
        
    }

    func setupApp(baseCountry:String,baseCity:String,destCountry:String,destCity:String){
        let emptyflagButton = app.buttons["emptyFlag"]
        emptyflagButton.tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts[baseCountry].tap()
        emptyflagButton.tap()
        tablesQuery.staticTexts[destCountry].tap()
        tablesQuery.staticTexts[baseCity].tap()
        tablesQuery.staticTexts[destCity].tap()
        
        
        let tapForPadStaticText = app.staticTexts["Tap for Pad"]
        tapForPadStaticText.tap()
    }
    
    func newCountry(baseCountry:String,baseCity:String,destCountry:String,destCity:String){
        app.buttons["ZA"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts[baseCountry].tap()
        app.buttons["IT"].tap()
        tablesQuery.staticTexts[destCountry].tap()
        tablesQuery.staticTexts[baseCity].tap()
        tablesQuery.staticTexts[destCity].tap()
        
    }
    
}

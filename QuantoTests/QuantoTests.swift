//
//  QuantoTests.swift
//  QuantoTests
//
//  Created by Tawanda Kanyangarara on 13/04/2017.
//  Copyright © 2017 Tawanda Kanyangarara. All rights reserved.
//

import XCTest
import Alamofire
import Firebase

@testable import Quanto

class QuantoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAlamofireReturns200(){
        let urlString = LASTEST_DEV_RATES
        let expectation = self.expectation(description: "request should succeed")
        
        var response: DefaultDataResponse?
        
        // When
        Alamofire.request(urlString).response { resp in
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        //Check status Code Repsonse not 401
        XCTAssertEqual(Int((response?.response?.statusCode)!),200,"Correct Response from Server")
        XCTAssertNil(response?.error)
        
        if #available(iOS 10.0, macOS 10.12, tvOS 10.0, *) {
            XCTAssertNotNil(response?.metrics)
        }
    }
    func testRatesAreLoaded(){
        
        let exchangeRates = CurrentExchange()
        let expect = expectation(description: "Algorithm Check")
        exchangeRates.downloadExchangeRates { JSON in
            XCTAssertNotNil(JSON, "Expected non-nil string")
            XCTAssertNotNil(exchangeRates.rates)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    
    }
    func _testConversionAlgo(){
        // Crashed cause the self.rates array is empty on testing----Figure Out
        let destC = "USD"
        let baseC = "ZAR"
        let price = Float(2)
        
        let exchangeRates = CurrentExchange()
        
        XCTAssertNotNil(exchangeRates.doConvertion(dest: destC, base: baseC, price: price))
        
        
    }
    func testFirebaseDB(){
        let expect = expectation(description: "FirebaseDB Check Connection")
        DataService.ds.REF_COUNTRIES.observe(.value, with: { (snapshot) in
            XCTAssertNotNil(snapshot)
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot {
                    XCTAssertNotNil(snap)
                }
            }
            expect.fulfill()
        })
        DataService.ds.REF_CITIES.observe(.value, with: { (snapshot) in
            XCTAssertNotNil(snapshot)
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot {
                    XCTAssertNotNil(snap)
                }
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: 5.0, handler: nil)

    }
    
}

//
//  coreTests.swift
//  coreTests
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

//import Cocoa
import XCTest
import LinCore

class coreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        //XCTAssert(true, "Pass")
//        var da = DeleteAction { (send:AnyObject) -> () in
//            println("ok.");
//        }
//        da.widthObjectSameLifecycle = self;
//        da.widthObjectSameLifecycle = nil;
//        da.widthObjectSameLifecycle = self;
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
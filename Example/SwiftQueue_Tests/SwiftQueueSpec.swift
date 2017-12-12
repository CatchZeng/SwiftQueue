//
//  SwiftQueueSpec.swift
//  SwiftQueue_Example
//
//  Created by CatchZeng on 2017/12/12.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Foundation
import SwiftQueue

class SwiftQueueSpec: QuickSpec {
    override func spec() {
        describe("SwiftQueeu") {
            context("OperationCount", {
                beforeEach {
                    SwiftQueue.shared.cancelAll()
                }
                
                it("Add operation will change operationCount.", closure: {
                    let expectation = self.expectation(description: "OperationCount")
                    
                    expect(SwiftQueue.shared.operationCount).to(equal(0))
                    
                    let operation = SwiftOperation {
                        Thread.sleep(forTimeInterval: 2)
                        expectation.fulfill()
                    }
                    SwiftQueue.shared.addOperation(operation)
                    
                    expect(SwiftQueue.shared.operationCount).to(equal(1))
                    
                    self.waitForExpectations(timeout: 3, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operationCount).to(equal(0))
                    })
                })
            })
            
            context("Operations", {
                beforeEach {
                    SwiftQueue.shared.cancelAll()
                }
                
                it("Add operation will change Operations.", closure: {
                    let expectation = self.expectation(description: "Operations")
                    
                    expect(SwiftQueue.shared.operations.isEmpty).toEventually(beTruthy())
                    
                    let operation = SwiftOperation {
                        Thread.sleep(forTimeInterval: 2)
                        expectation.fulfill()
                    }
                    SwiftQueue.shared.addOperation(operation)
                    
                    expect(SwiftQueue.shared.operations.contains(operation)).toEventually(beTruthy())
                    
                    self.waitForExpectations(timeout: 3, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operations.contains(operation)).toEventually(beFalsy())
                    })
                })
            })
        }
    }
}

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
                        Thread.sleep(forTimeInterval: 1)
                        expectation.fulfill()
                    }
                    SwiftQueue.shared.addOperation(operation)
                    
                    expect(SwiftQueue.shared.operationCount).to(equal(1))
                    
                    self.waitForExpectations(timeout: 2, handler: { (error) in
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
                        Thread.sleep(forTimeInterval: 1)
                        expectation.fulfill()
                    }
                    SwiftQueue.shared.addOperation(operation)
                    
                    expect(SwiftQueue.shared.operations.contains(operation)).toEventually(beTruthy())
                    
                    self.waitForExpectations(timeout: 2, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operations.contains(operation)).toEventually(beFalsy())
                    })
                })
            })
            
            context("MaxConcurrentOperationCount", {
                it("Set maxConcurrentOperationCount", closure: {
                    SwiftQueue.shared.maxConcurrentOperationCount = 5
                    expect(SwiftQueue.shared.maxConcurrentOperationCount).to(equal(5))
                })
            })
            
            context("Init", {
                it("Init with name", closure: {
                    let queue = SwiftQueue(name: "Init with name")
                    expect(queue.queue.name).to(equal("Init with name"))
                })
                
                it("Init with name&maxConcurrentOperationCount", closure: {
                    let queue = SwiftQueue(name: "Init with name&maxConcurrentOperationCount", maxConcurrentOperationCount: 10)
                    expect(queue.queue.name).to(equal("Init with name&maxConcurrentOperationCount"))
                    expect(queue.maxConcurrentOperationCount).to(equal(10))
                })
            })
            
            context("AddOperation", {
                it("Block Operation", closure: {
                    let queue = SwiftQueue(name: "Block Operation")
                    let expectation = self.expectation(description: "Block Operation")
                    
                    queue.addOperation({
                        Thread.sleep(forTimeInterval: 1)
                        expectation.fulfill()
                    })
                    
                    self.waitForExpectations(timeout: 2, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operationCount).to(equal(0))
                    })
                })
                
                it("Normal Operation", closure: {
                    let queue = SwiftQueue(name: "Normal Operation")
                    let expectation = self.expectation(description: "Normal Operation")
                    
                    let operation = SwiftOperation {
                        Thread.sleep(forTimeInterval: 1)
                        expectation.fulfill()
                    }
                    queue.addOperation(operation)
                    
                    self.waitForExpectations(timeout: 2, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operationCount).to(equal(0))
                    })
                })
                
                it("Operations", closure: {
                    let queue = SwiftQueue(name: "Operations")
                    let expectation = self.expectation(description: "Operations")
                    
                    var total = 0
                    let operation = SwiftOperation {
                        total+=1
                    }
                    let operation2 = SwiftOperation {
                        total+=1
                    }
                    queue.addOperation(operation)
                    queue.addOperation(operation2)
                   
                    let deadline = DispatchTime.now() + .seconds(1)
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: deadline) {
                        expectation.fulfill()
                    }
                    
                    self.waitForExpectations(timeout: 2, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operationCount).to(equal(0))
                    })
                })
                
                it("ChainedOperations", closure: {
                    let queue = SwiftQueue(name: "ChainedOperations")
                    let expectation = self.expectation(description: "ChainedOperations")
                    
                    var total = [0]
                    let operation = SwiftOperation {
                        total.append(1)
                    }
                    let operation2 = SwiftOperation {
                        total.append(2)
                    }
                    queue.addChainedOperations(operation, operation2, completionHandler: {
                        total.append(3)
                        expectation.fulfill()
                    })
                    
                    self.waitForExpectations(timeout: 2, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operationCount).to(equal(0))
                        expect(total).to(equal([0, 1, 2, 3]))
                    })
                })
                
                it("ChainedOperations Array", closure: {
                    let queue = SwiftQueue(name: "ChainedOperations Array")
                    let expectation = self.expectation(description: "ChainedOperations Array")
                    
                    var total = [0]
                    let operation = SwiftOperation {
                        total.append(1)
                    }
                    let operation2 = SwiftOperation {
                        total.append(2)
                    }
                    queue.addChainedOperations([operation, operation2], completionHandler: {
                        total.append(3)
                        expectation.fulfill()
                    })
                    
                    self.waitForExpectations(timeout: 1, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operationCount).to(equal(0))
                        expect(total).to(equal([0, 1, 2, 3]))
                    })
                })
                
                it("Empty chainedOperations", closure: {
                    let queue = SwiftQueue(name: "Empty chainedOperations")
                    let expectation = self.expectation(description: "Empty chainedOperations")
                    
                    var total = [0]
                    queue.addChainedOperations([], completionHandler: {
                        total.append(1)
                        expectation.fulfill()
                    })
                    
                    self.waitForExpectations(timeout: 1, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operationCount).to(equal(0))
                        expect(total).to(equal([0, 1]))
                    })
                })
                
                it("ChainedOperations without completionHandler", closure: {
                    let queue = SwiftQueue(name: "ChainedOperations without completionHandler")
                    let expectation = self.expectation(description: "ChainedOperations without completionHandler")
                    
                    var total = [0]
                    let operation = SwiftOperation {
                        total.append(1)
                    }
                    let operation2 = SwiftOperation {
                        total.append(2)
                        expectation.fulfill()
                    }
                    queue.addChainedOperations([operation, operation2])
                    
                    self.waitForExpectations(timeout: 1, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operationCount).to(equal(0))
                        expect(total).to(equal([0, 1, 2]))
                    })
                })
            })
            
            context("CancelAll", {
                it("CancelAll", closure: {
                    let queue = SwiftQueue(name: "CancelAll")
                    let expectation = self.expectation(description: "CancelAll")
                    
                    var total = [0]
                    let operation = SwiftOperation {
                        Thread.sleep(forTimeInterval: 2)
                        total.append(1)
                    }
                    
                    let operation2 = SwiftOperation {
                        total.append(2)
                    }
                    
                    queue.addChainedOperations([operation, operation2])
                    
                    queue.cancelAll()
                    
                    let deadline = DispatchTime.now() + .milliseconds(500)
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: deadline) {
                        expectation.fulfill()
                    }
                    
                    self.waitForExpectations(timeout: 5, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(SwiftQueue.shared.operationCount).to(equal(0))
                        expect(total).to(equal([0, 2]))
                    })
                })
            })
            
            context("PauseAndResume", {
                it("PauseAndResume", closure: {
                    let queue = SwiftQueue(name: "PauseAndResume")
                    let expectation = self.expectation(description: "PauseAndResume")
                    
                    var total = [0]
                    let operation = SwiftOperation {
                        Thread.sleep(forTimeInterval: 2)
                        total.append(1)
                    }
                    
                    let operation2 = SwiftOperation {
                        total.append(2)
                    }
                    
                    queue.addChainedOperations([operation, operation2], completionHandler: {
                        total.append(3)
                    })
                    
                    queue.pause()
                    expectation.fulfill()
                    
                    self.waitForExpectations(timeout: 3, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(queue.isExecuting).toEventually(beFalsy())
                        expect(total).to(equal([0]))
                        
                        queue.resume()
                        expect(queue.isExecuting).toEventually(beTruthy())
                    })
                })
            })
            
            context("PauseAndResume", {
                it("PauseAndResume", closure: {
                    let queue = SwiftQueue(name: "PauseAndResume")
                    let expectation = self.expectation(description: "PauseAndResume")
                    
                    var total = [0]
                    let operation = SwiftOperation {
                        Thread.sleep(forTimeInterval: 2)
                        total.append(1)
                    }
                    
                    let operation2 = SwiftOperation {
                        total.append(2)
                    }
                    
                    queue.addChainedOperations([operation, operation2], completionHandler: {
                        total.append(3)
                    })
                    
                    queue.waitUntilAllOperationsAreFinished()
                    
                    expect(total).to(equal([0, 1, 2, 3]))
                    
                    expectation.fulfill()
                    
                    self.waitForExpectations(timeout: 3, handler: { (error) in
                        expect(error).toEventually(beNil())
                        expect(queue.isExecuting).toEventually(beTruthy())
                    })
                })
            })
        }
    }
}

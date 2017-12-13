//
//  SwiftQueue.swift
//  SwiftQueue_Example
//
//  Created by CatchZeng on 2017/12/12.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation

open class SwiftQueue {
    
    public static let shared: SwiftQueue = SwiftQueue(name: "SwiftQueue")
    
    public var operationCount: Int {
        return self.mQueue.operationCount
    }
    
    public var operations: [Operation] {
        return self.mQueue.operations
    }
    
    public var maxConcurrentOperationCount: Int {
        get {
            return self.mQueue.maxConcurrentOperationCount
        }
        set {
            self.mQueue.maxConcurrentOperationCount = newValue
        }
    }
    
    public var isExecuting: Bool {
        return !self.mQueue.isSuspended
    }
    
    public var queue: OperationQueue {
        return mQueue
    }
    
    private let mQueue: OperationQueue = OperationQueue()
    
    public init(name: String, maxConcurrentOperationCount: Int = Int.max) {
        self.mQueue.name = name
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
    public func addOperation(_ operation: @escaping () -> Void) {
        self.mQueue.addOperation(operation)
    }
    
    public func addOperation(_ operation: Operation) {
        self.mQueue.addOperation(operation)
    }
    
    public func addChainedOperations(_ operations: [Operation], completionHandler: (() -> Void)? = nil) {
        for (index, operation) in operations.enumerated() {
            if index > 0 {
                operation.addDependency(operations[index - 1])
            }
            
            self.addOperation(operation)
        }
        
        guard let completionHandler = completionHandler else {
            return
        }
        
        let completionOperation = BlockOperation(block: completionHandler)
        if !operations.isEmpty {
            completionOperation.addDependency(operations[operations.count - 1])
        }
        self.addOperation(completionOperation)
    }
    
    public func addChainedOperations(_ operations: Operation..., completionHandler: (() -> Void)? = nil) {
        self.addChainedOperations(operations, completionHandler: completionHandler)
    }
    
    public func cancelAll() {
        self.mQueue.cancelAllOperations()
    }
    
    public func pause() {
        self.mQueue.isSuspended = true
        
        for operation in self.mQueue.operations where operation is SwiftOperation {
            (operation as? SwiftOperation)?.pause()
        }
    }
    
    public func resume() {
        self.mQueue.isSuspended = false
        
        for operation in self.mQueue.operations where operation is SwiftOperation {
            (operation as? SwiftOperation)?.resume()
        }
    }
    
    public func waitUntilAllOperationsAreFinished() {
        self.mQueue.waitUntilAllOperationsAreFinished()
    }
}

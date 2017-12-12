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
            context("addOperation", {
                beforeEach {
                    SwiftQueue.shared.cancelAll()
                }
                
                it("check operationCount when add simple Operation", closure: {
                    SwiftQueue.shared.addOperation {
                        print("addOperation 1")
                        print("addOperation 2")
                        print("addOperation 2")
                        print("addOperation 2")
                        print("addOperation 2")
                    }
                    expect(SwiftQueue.shared.operationCount).to(equal(0))
                })
                it("check operationCount when add time-consuming Operation", closure: {
                    SwiftQueue.shared.addOperation {
                        for i in 0..<5 {
                            print("addOperation\(i)")
                        }
                    }
                    expect(SwiftQueue.shared.operationCount).to(equal(1))
                })
            })
        }
    }
}

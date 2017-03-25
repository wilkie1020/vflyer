
//
//  Promise.swift
//  VFlyer
//
//  Created by Brayden Streibel on 2017-03-25.
//  Copyright © 2017 Mat Wilkie. All rights reserved.
//

import Foundation

class Promise {
    var pending: [(() -> ())] = []
    var fail: (() -> ()) = {}
    var rejected: Bool = false
    
    class func `defer`() -> Promise {
        return Promise()
    }
    
    func resolve() ->(() -> ()) {
        func resolve() -> () {
            for f in self.pending {
                if self.rejected {
                    fail()
                    return
                }
                f()
            }
            if self.rejected {
                fail()
                return
            }
        }
        return resolve
    }
    
    func reject() -> () {
        self.rejected = true
    }
    
    func then(success: @escaping (() -> ())) -> Promise {
        self.pending.append(success)
        return self
    }
    
    func fail(fail: @escaping (() -> ())) -> Promise {
        self.fail = fail
        return self
    }
}

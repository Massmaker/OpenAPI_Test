//
//  WeakObject.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

/// This class is used for breaking reference cycle and removes the need of using the _ *weak var* _  keywords when using objects of some protocols inside classes.
final class WeakObject<T:AnyObject> {
    private(set) weak var object:T?
    
    init(_ obj:T) {
        self.object = obj
    }
}


enum WeakObjectError:Error {
    case noUnderlyingObject
}


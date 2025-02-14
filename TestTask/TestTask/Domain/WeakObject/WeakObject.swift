//
//  WeakObject.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

final class WeakObject<T:AnyObject> {
    private(set) weak var object:T?
    
    init(_ obj:T) {
        self.object = obj
    }
}


enum WeakObjectError:Error {
    case noUnderlyingObject
}


//
//  Paging.swift
//  TestTask
//
//  Created by Ivan_Tests on 07.02.2025.
//

import Foundation
struct PageInfo {
    let hasNext:Bool
    let nextCursor:String?
    static let `default`: PageInfo = PageInfo(hasNext: true, nextCursor: nil)
}

protocol Pageable {
    associatedtype Value : Identifiable & Hashable
    func loadPage(after currentPage:PageInfo, size:Int) async throws -> (items:[Value], pageInfo:PageInfo)
}



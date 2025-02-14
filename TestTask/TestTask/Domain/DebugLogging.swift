//
//  DebugLogging.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation
import OSLog


func createLogger(subsystem:String, category:String) -> Logger {
    #if DEBUG
    Logger(subsystem: subsystem, category: category)
    #else
    Logger(.disabled)
    #endif
}

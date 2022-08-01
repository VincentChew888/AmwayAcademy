//
//  AmwayAppLogger.swift
//  
//
//  Created by Tahir Gani on 01/07/22.
//

import Foundation
import OSLog

protocol AmwayAppLoggerLogic {
    func debug(_ message: String, file: String, line: Int)
    func log(message: String, type: OSLogType)
}

extension AmwayAppLoggerLogic {
    func debug(_ message: String, file: String = #file, line: Int = #line) {
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            let logMessage = "[\(fileName):\(line)] \(message)"

            log(message: logMessage, type: OSLogType.debug)
        #endif
    }
}

struct AmwayAppLogger: AmwayAppLoggerLogic {
    static var generalLogger = AmwayAppLogger(category: .general)
    
    enum Category: String {
        case general = "General"
        case nudge = "Nudge"
        case widget = "Amway Widget"
        case tokenManager = "Token Manager"
        case queryClient = "Query Client"
        case programs = "Programs"
        case customers = "Customers"
        case customerProfile = "Customer Profile"
        case unexpected = "Unexpected"
        case notImplemented = "Not Implemented"
        case serviceError = "Service Error"
        case dateError = "Date Error"
        case keychain = "Creators Keychain"
        case dataStore = "Creators Data Store"
        case remoteLogging = "Remote Logger"
        case leads = "Leads"
        case cloudKit = "CloudKit"
        case appConfig = "App Config"
        case heapAnalytics = "Heap Analytics"
        case utmFields = "UTM Fields"
        case events
    }

    private let logger: Logger

    init(category: Category = .general) {
        logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                        category: category.rawValue)
    }

    func log(message: String, type: OSLogType) {
        if case .debug = type {
            logger.log(level: type, "\(message, privacy: .public)")
        } else {
            logger.log(level: type, "\(message)")
        }
    }

    func info(_ message: String) {
        log(message: message, type: OSLogType.info)
    }

    func error(_ message: String) {
        log(message: message, type: OSLogType.error)
    }

    func fault(_ message: String) {
        log(message: message, type: OSLogType.fault)
    }

    func critical(_ message: String) {
        fault(message)
    }
}

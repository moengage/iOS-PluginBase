//
//  MoEngageCardsPluginLogger.swift
//  moengage_cards
//
//  Created by Soumya Mahunt on 05/07/23.
//

import Foundation
import MoEngageCore
import MoEngagePluginBase

public enum MoEngagePluginCardsLogger {
    private static let label = "Cards"
    private static var sdkInstance: MoEngageSDKInstance?

    public static func debug(_ message: String, forData hybridData: [String: Any]) {
        queueLog(message, forData: hybridData, withType: .debug)
    }

    public static func error(
        _ message: String,
        forData hybridData: [String: Any] = [:],
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        queueLog(
            message, forData: hybridData, withType: .error,
            file: file, function: function, line: line, column: column
        )
    }

    private static func queueLog(
        _ message: String,
        forData hybridData: [String: Any],
        withType type: MoEngageLoggerType,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        if let sdkInstance = Self.sdkInstance {
            log(
                message, withPayload: hybridData, withType: type, inInstance: sdkInstance,
                file: file, function: function, line: line, column: column
            )
        } else if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
            attribute: hybridData
        ) {
            MoEngageCoreHandler.globalQueue.async  {
                guard let instance = MoEngageSDKInstanceProvider.sharedInstance.getSdkInstance(identifier) else { return }
                Self.sdkInstance = instance
                log(
                    message, withPayload: hybridData, withType: type, inInstance: instance,
                    file: file, function: function, line: line, column: column
                )
            }
        }
    }

    private static func log(
        _ message: String,
        withPayload payload: [String: Any],
        withType type: MoEngageLoggerType,
        inInstance sdkInstance: MoEngageSDKInstance,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        let finalMessage = generateLogs(message: message, payload: payload)
        switch type {
        case .debug:
            sdkInstance.logger.log(logLevel: .debug, message: finalMessage)
        case .error:
            sdkInstance.logger.log(logLevel: .error, message: finalMessage)
        case .info:
            sdkInstance.logger.log(logLevel: .info, message: finalMessage)
        case .verbose:
            sdkInstance.logger.log(logLevel: .verbose, message: finalMessage)
        case .warning:
            sdkInstance.logger.log(logLevel: .warning, message: finalMessage)
        @unknown default:
            sdkInstance.logger.log(logLevel: .verbose, message: finalMessage)
        }
    }
    
    private static func generateLogs(message: String, payload: [String: Any]) -> String {
        return "\(message) \(payload)"
    }
}

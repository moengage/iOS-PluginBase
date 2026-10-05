//
//  MoEngagePluginUtils+FailureReason.swift
//  MoEngagePluginBase
//
//  Created by Rakshitha on 05/10/26.
//

import Foundation
import MoEngageCore

extension MoEngagePluginUtils {

    /// Maps a shared SDK failure code to the common hybrid failure reason.
    ///
    /// Module specific codes are mapped by the respective module; this covers the
    /// SDK-wide codes any module can fail with.
    public static func hybridReason(forSharedCode code: MoEngageRequestFailureReason.Code) -> String {
        typealias FailureReason = MoEngagePluginConstants.FailureReason
        switch code {
        case .sdkNotInitialized:
            return FailureReason.sdkState
        case .featureDisabled:
            return FailureReason.featureDisabled
        case .networkError:
            return FailureReason.networkError
        case .parseError:
            return FailureReason.parseError
        case .invalidParameters:
            return FailureReason.invalidParameters
        case .serverError:
            return FailureReason.serverError
        case .authenticationFailed:
            return FailureReason.authenticationFailed
        case .unknownError, .requiredPermissionMissing, .cancelled:
            return FailureReason.unknownError
        @unknown default:
            return FailureReason.unknownError
        }
    }
}

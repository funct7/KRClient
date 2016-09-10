//
//  KRClientError.swift
//  Pods
//
//  Created by Joshua Park on 9/8/16.
//
//

public struct ErrorDomain {
    static let Default = "com.KRClient"
    static let Request = "\(ErrorDomain.Default).request"
    static let Response = "\(ErrorDomain.Default).response"
}

public struct ErrorCode {
    static let Unknown = -9999
    static let InvalidOperation = -10
    static let RequestFailed = -20
    static let FailedToConvertStringToURL = -21
    static let DataFailedToPassValidation = -30
    static let DataFailedToConvertToString = -40
}

public enum Error: ErrorType {
    case InvalidOperation(description: String?, file: String, line: Int)
    case RequestFailed(description: String?)
    case FailedToConvertStringToURL(string: String)
    case DataFailedToPassValidation(description: String?, failureReason: String?)
    case DataFailedToConvertToString
}

internal func getErrorFromStruct(errorStruct: Error?) -> NSError {
    if let error = errorStruct {
        switch error {
            
        case .InvalidOperation(description: let description, file: let file, line: let line):
            return NSError(domain: ErrorDomain.Request, code: ErrorCode.RequestFailed, userInfo: [
                NSLocalizedDescriptionKey: "An invalid operation was attempted.",
                NSLocalizedFailureReasonErrorKey: description ?? "Unknown.",
                NSLocalizedRecoverySuggestionErrorKey: "Check \(file):\(line)"
                ])
            
        case .RequestFailed(let description):
            return NSError(domain: ErrorDomain.Request, code: ErrorCode.RequestFailed, userInfo: [
                NSLocalizedDescriptionKey: "Failed to make a URL request.",
                NSLocalizedFailureReasonErrorKey: description ?? "Unknown."
                ])
            
        case .FailedToConvertStringToURL(string: let string):
            return NSError(domain: ErrorDomain.Request, code: ErrorCode.FailedToConvertStringToURL, userInfo: [
                NSLocalizedDescriptionKey: "Failed to initialze an NSURL instance with string: \(string)."
                ])
            
        case .DataFailedToPassValidation(description: let description, failureReason: let failureReason):
            return NSError(domain: ErrorDomain.Response, code: ErrorCode.DataFailedToPassValidation, userInfo:[
                NSLocalizedDescriptionKey: description ?? "The response data failed to pass validation.",
                NSLocalizedFailureReasonErrorKey: failureReason ?? "Unknown."
                ])
            
        case .DataFailedToConvertToString:
            return NSError(domain: ErrorDomain.Response, code: ErrorCode.DataFailedToConvertToString, userInfo: [
                NSLocalizedDescriptionKey: "The response data failed to convert to string.",
            ])
            
        }
    } else {
        return NSError(domain: ErrorDomain.Default, code: ErrorCode.Unknown, userInfo: [
            NSLocalizedDescriptionKey: "An unknown error has occurred."
            ])

    }
    
}
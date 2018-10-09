//
//  File.swift
//  CCNetwork
//
//  Created by ash on 2018/9/29.
//

import Foundation

public struct CCResponse<Value> {
    
    public let request: CCRequest
    
    public let result: CCResult<Value>
    
    public init(request: CCRequest, result: CCResult<Value>) {
        self.request = request
        self.result = result
    }
    
}

extension CCResponse: CustomDebugStringConvertible, CustomStringConvertible {
    
    public var description: String {
        return result.debugDescription
    }
    
    public var debugDescription: String {
        var output: [String] = []
        
        output.append(request != nil ? "[Request]: \(request.requestMethod) \(request)" : "[Request]: nil")
        output.append("[Result]: \(result.debugDescription)")
        
        return output.joined(separator: "\n")
    }
    
}


// MARK: -

extension CCResponse {
    
    public func map<T>(_ transform: (Value) -> T) -> CCResponse<T> {
        var response = CCResponse<T>(
            request: request,
            result: result.map(transform)
        )
        return response
    }
    
    public func flatMap<T>(_ transform: (Value) throws -> T) -> CCResponse<T> {
        var response = CCResponse<T>(
            request: request,
            result: result.flatMap(transform)
        )
        
        return response
    }
    
    public func mapError<E: Error>(_ transform: (Error) -> E) -> CCResponse {
        var response = CCResponse(
            request: request,
            result: result.mapError(transform)
        )
        
        return response
    }
    
    public func flatMapError<E: Error>(_ transform: (Error) throws -> E) -> CCResponse {
        var response = CCResponse(
            request: request,
            result: result.flatMapError(transform)
        )
        
        return response
    }
}






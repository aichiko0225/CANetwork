//
//  CCResult.swift
//  CCNetwork
//
//  Created by ash on 2018/9/29.
//

import Foundation


public enum CCResult<Value> {
    case success(Value)
    case failure(Error)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

// MARK: - CustomStringConvertible

extension CCResult: CustomStringConvertible {
    /// The textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure.
    public var description: String {
        switch self {
        case .success:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension CCResult: CustomDebugStringConvertible {
    /// The debug textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure in addition to the value or error.
    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}

extension CCResult {
    
    public init(value: () throws -> Value) {
        do {
            self = try .success(value())
        } catch {
            self = .failure(error)
        }
    }
    
    public func unwrap() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    
    public func map<T>(_ transform: (Value) -> T) -> CCResult<T> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func flatMap<T>(_ transform: (Value) throws -> T) -> CCResult<T> {
        switch self {
        case .success(let value):
            do {
                return try .success(transform(value))
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func mapError<T: Error>(_ transform: (Error) -> T) -> CCResult {
        switch self {
        case .failure(let error):
            return .failure(transform(error))
        case .success:
            return self
        }
    }
    
    public func flatMapError<T: Error>(_ transform: (Error) throws -> T) -> CCResult {
        switch self {
        case .failure(let error):
            do {
                return try .failure(transform(error))
            } catch {
                return .failure(error)
            }
        case .success:
            return self
        }
    }
    
    @discardableResult
    public func withValue(_ closure: (Value) -> Void) -> CCResult {
        if case let .success(value) = self { closure(value) }
        
        return self
    }
    
    @discardableResult
    public func withError(_ closure: (Error) -> Void) -> CCResult {
        if case let .failure(error) = self { closure(error) }
        
        return self
    }
    
    @discardableResult
    public func ifSuccess(_ closure: () -> Void) -> CCResult {
        if isSuccess { closure() }
        
        return self
    }
    
    @discardableResult
    public func ifFailure(_ closure: () -> Void) -> CCResult {
        if isFailure { closure() }
        
        return self
    }
    
}

